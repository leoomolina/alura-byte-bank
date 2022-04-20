// ignore_for_file: import_of_legacy_library_into_null_safe
import 'dart:async';
import 'package:bytebank/components/byte_bank_app_bar.dart';
import 'package:bytebank/components/container.dart';
import 'package:bytebank/components/progress.dart';
import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:bytebank/models/contato.dart';
import 'package:bytebank/models/transacao.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:uuid/uuid.dart';

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
  const FatalErrorTransactionFormState();
}

class TransactionFormCubit extends Cubit<TransactionFormState> {
  TransactionFormCubit() : super(ShowFormState());
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
      child: _TransactionFormStateless(_contato),
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
        if (state is ShowFormState) return _BasicForm(this.contato);

        if (state is SendingState) return ProgressView();

        if (state is SentState) Navigator.pop(context);

        return Text("Erro!");
      },
    ));
  }

  void _save(
    Transacao transactionCreated,
    String password,
    BuildContext context,
  ) async {
    Transacao? transaction = await _send(transactionCreated, password, context);

    await _showSuccessfulMessage(transaction, context);
  }

  Future<Transacao?> _send(Transacao transactionCreated, String password,
      BuildContext context) async {
    // setState(() {
    //   _carregandoDados = true;
    // });
    final TransactionWebClient _webClient = TransactionWebClient();

    final Transacao? transaction =
        await _webClient.save(transactionCreated, password).catchError((e) {
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.setCustomKey('exception', e.toString());
        FirebaseCrashlytics.instance.setCustomKey('http_code', e.statusCode);
        FirebaseCrashlytics.instance
            .setCustomKey('http_body', transactionCreated.toString());

        FirebaseCrashlytics.instance.recordError(e, null);
      }

      _showFailureMessage(context, message: 'Erro de timeout');
    }, test: (e) => e is TimeoutException).catchError((e) {
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.setCustomKey('exception', e.toString());
        FirebaseCrashlytics.instance.setCustomKey('http_code', e.statusCode);
        FirebaseCrashlytics.instance
            .setCustomKey('http_body', transactionCreated.toString());

        FirebaseCrashlytics.instance.recordError(e, null);
      }

      _showFailureMessage(context, message: e.message);
    }, test: (e) => e is HttpException).catchError((e) {
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.setCustomKey('exception', e.toString());
        FirebaseCrashlytics.instance.setCustomKey('http_code', e.statusCode);
        FirebaseCrashlytics.instance
            .setCustomKey('http_body', transactionCreated.toString());

        FirebaseCrashlytics.instance.recordError(e.toString(), null);
      }

      _showFailureMessage(context);
    }, test: (e) => e is Exception).whenComplete(() {
      // setState(() {
      //   _carregandoDados = false;
      // });
    });
    return transaction;
  }

  void _showFailureMessage(BuildContext context,
      {message = 'Erro desconhecido'}) {
    //Toast.show(message, context, gravity: Toast.BOTTOM);

    showDialog(
      context: context,
      builder: (_) => NetworkGiffyDialog(
        image: Image.asset('images/error.gif'),
        title: Text('OPS',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
        description: Text(
          message,
          textAlign: TextAlign.center,
        ),
        entryAnimation: EntryAnimation.TOP,
      ),
    );
  }

  Future<void> _showSuccessfulMessage(
      Transacao? transaction, BuildContext context) async {
    if (transaction != null) {
      await showDialog(
          context: context,
          builder: (contextDialog) {
            return SuccessDialog('Transação gravada com sucesso');
          });
      Navigator.pop(context);
    }
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
                                //_save(transactionCreated, password, context);
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
