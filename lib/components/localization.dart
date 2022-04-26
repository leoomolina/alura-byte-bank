// LOCALIZATION E INTERNACIONALIZATION

import 'package:bytebank/components/error.dart';
import 'package:bytebank/components/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'container.dart';

@immutable
class InitI18NMessagesState extends I18NMessagesState {
  const InitI18NMessagesState();
}

@immutable
abstract class I18NMessagesState {
  const I18NMessagesState();
}

@immutable
class LoadingI18NMessagesState extends I18NMessagesState {
  const LoadingI18NMessagesState();
}

@immutable
class LoadedI18NMessagesState extends I18NMessagesState {
  final I18NMessages _messages;

  const LoadedI18NMessagesState(this._messages);
}

class I18NMessages {
  Map<String, String> _messages;

  I18NMessages(this._messages);

  String? get(String key) {
    assert(_messages.containsKey(key));

    return _messages[key];
  }
}

@immutable
class FatalErrorI18NMessagesState extends I18NMessagesState {
  const FatalErrorI18NMessagesState();
}

class LocalizationContainer extends BlocContainer {
  final Widget child;

  LocalizationContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CurrentLocaleCubit(),
      child: this.child,
    );
  }
}

class CurrentLocaleCubit extends Cubit<String> {
  CurrentLocaleCubit() : super("en");
}

class ViewI18N {
  String? _language;

  ViewI18N(BuildContext context) {
    this._language = BlocProvider.of<CurrentLocaleCubit>(context).state;
  }

  String? localize(Map<String, String> values) {
    assert(values.containsKey(_language));

    return values[_language];
  }
}

typedef Widget I18NWidgetCreator(I18NMessages messages);

class I18NLoadingContainer extends BlocContainer {
  final I18NWidgetCreator _creator;

  I18NLoadingContainer(this._creator);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<I18NMessagesCubit>(
      create: (BuildContext context) {
        final cubit = I18NMessagesCubit();
        cubit.reload();
        return cubit;
      },
      child: I18NLoadingView(this._creator),
    );
  }
}

class I18NLoadingView extends StatelessWidget {
  final I18NWidgetCreator _creator;

  I18NLoadingView(this._creator);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<I18NMessagesCubit, I18NMessagesState>(
      builder: (context, state) {
        if (state is LoadingI18NMessagesState || state is InitI18NMessagesState)
          return Progress("Carregando");
        if (state is LoadedI18NMessagesState) {
          final messages = state._messages;
          return _creator.call(messages);
        }
        return ErrorView("Erro ao carregar idioma");
      },
    );
  }
}

class I18NMessagesCubit extends Cubit<I18NMessagesState> {
  I18NMessagesCubit() : super(InitI18NMessagesState());

  void reload() async {
    emit(LoadingI18NMessagesState());

    emit(LoadedI18NMessagesState(I18NMessages({
      "transferencia": "TRANSFER",
      "transaction_feed": "TRANSACTION",
      "alterar_nome": "NOME",
    })));
  }
}
