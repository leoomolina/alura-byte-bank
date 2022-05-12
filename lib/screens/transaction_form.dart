// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';
import 'package:bytebank/components/byte_bank_app_bar.dart';
import 'package:bytebank/components/container.dart';
import 'package:bytebank/components/error_view.dart';
import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:bytebank/models/contato.dart';
import 'package:bytebank/models/transacao.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

import '../components/progress/progress_view.dart';

@immutable
abstract class TransactionFormState {
  const TransactionFormState();
}

@immutable
class ShowFormState extends TransactionFormState {
  const ShowFormState();
}

@immutable
class SendingState extends TransactionFormState {
  const SendingState();
}

@immutable
class SentState extends TransactionFormState {
  const SentState();
}

@immutable
class FatalErrorTransactionFormState extends TransactionFormState {
  final String _message;

  const FatalErrorTransactionFormState(this._message);
}

class TransactionFormCubit extends Cubit<TransactionFormState> {
  TransactionFormCubit() : super(ShowFormState());

  void save(Transacao transactionCreated, String password,
      BuildContext context) async {
    emit(SendingState());
    await _send(transactionCreated, password, context);
  }

  _send(Transacao transactionCreated, String password,
      BuildContext context) async {
    await TransactionWebClient()
        .save(transactionCreated, password)
        .then((transaction) => emit(SentState()))
        .catchError((e) {
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.setCustomKey('exception', e.toString());
        FirebaseCrashlytics.instance.setCustomKey('http_code', e.statusCode);
        FirebaseCrashlytics.instance
            .setCustomKey('http_body', transactionCreated.toString());

        FirebaseCrashlytics.instance.recordError(e, null);
      }

      emit(FatalErrorTransactionFormState('Erro de timeout'));
    }, test: (e) => e is TimeoutException).catchError((e) {
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.setCustomKey('exception', e.toString());
        FirebaseCrashlytics.instance.setCustomKey('http_code', e.statusCode);
        FirebaseCrashlytics.instance
            .setCustomKey('http_body', transactionCreated.toString());

        FirebaseCrashlytics.instance.recordError(e, null);
      }

      emit(FatalErrorTransactionFormState(e.message));
    }, test: (e) => e is HttpException).catchError((e) {
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.setCustomKey('exception', e.toString());
        FirebaseCrashlytics.instance.setCustomKey('http_code', e.statusCode);
        FirebaseCrashlytics.instance
            .setCustomKey('http_body', transactionCreated.toString());

        FirebaseCrashlytics.instance.recordError(e.toString(), null);
      }

      emit(FatalErrorTransactionFormState(e.message));
    }, test: (e) => e is Exception).whenComplete(() {});
  }
}

class TransactionFormContainer extends BlocContainer {
  final Contato _contato;

  TransactionFormContainer(this._contato);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionFormCubit>(
      create: (BuildContext context) {
        return TransactionFormCubit();
      },
      child: BlocListener<TransactionFormCubit, TransactionFormState>(
          listener: (context, state) async {
            if (state is SentState) {
              Toast.show('Transação gravada com sucesso', context,
                  gravity: Toast.BOTTOM);

              Navigator.pop(context);
            }
          },
          child: _TransactionFormStateless(_contato)),
    );
  }
}

class _TransactionFormStateless extends StatelessWidget {
  final Contato contato;

  _TransactionFormStateless(this.contato);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<TransactionFormCubit, TransactionFormState>(
      builder: (context, state) {
        if (state is ShowFormState) {
          return _BasicForm(this.contato);
        }

        if (state is SendingState || state is SentState) {
          return ProgressView();
        }

        if (state is FatalErrorTransactionFormState) {
          return ErrorView(state._message);
        }

        return ErrorView("Erro desconhecido!");
      },
    ));
  }
}

class _BasicForm extends StatelessWidget {
  final Contato contato;

  final TextEditingController _valueController = TextEditingController();
  final String idTransacao = Uuid().v4();

  _BasicForm(this.contato);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ByteBankAppBar(
        context: context,
        title: 'Nova Transação',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                contato.nome,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  contato.numeroConta.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Valor'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Transferir'),
                    onPressed: () {
                      final double? value =
                          double.tryParse(_valueController.text);

                      if (value == null) {
                        showDialog(
                            context: context,
                            builder: (contextDialog) {
                              return FailureDialog(
                                  'Insira o valor da transferência');
                            });
                      }

                      final transactionCreated =
                          Transacao(idTransacao, value!, contato);

                      showDialog(
                          context: context,
                          builder: (contextDialog) {
                            return TransactionAuthDialog(
                              onConfirm: (String password) {
                                BlocProvider.of<TransactionFormCubit>(context)
                                    .save(
                                        transactionCreated, password, context);
                              },
                            );
                          });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
