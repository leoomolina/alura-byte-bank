import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/container.dart';
import '../components/localization.dart';
import '../models/name.dart';
import 'name.dart';

class DashboardContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NameCubit('Leonardo'),
      child: I18NLoadingContainer(
        (messages) => DashboardView(DashboardViewLazyI18N(messages)),
      ),
    );
  }
}

class DashboardView extends StatelessWidget {
  final DashboardViewLazyI18N _i18n;

  DashboardView(this._i18n);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NameCubit, String>(
          builder: (context, state) => Text('Bem-vindo $state'),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Image.asset('images/bytebank_logo.png')),
          ),
          SingleChildScrollView(
            child: Container(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _FeatureItem(
                    _i18n.transferencia!,
                    Icons.monetization_on,
                    onClick: () {
                      _mostrarListaContatos(context);
                    },
                  ),
                  _FeatureItem(
                    _i18n.transaction_feed!,
                    Icons.description,
                    onClick: () {
                      _mostrarListaTransacoes(context);
                    },
                  ),
                  _FeatureItem(
                    _i18n.alterar_nome!,
                    Icons.person_outline,
                    onClick: () {
                      _mostrarAlterarNome(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarListaContatos(BuildContext blocContext) {
    push(blocContext, ContactsListContainer());
  }

  void _mostrarListaTransacoes(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TransactionsList(),
    ));
  }

  void _mostrarAlterarNome(BuildContext blocContext) {
    Navigator.of(blocContext).push(MaterialPageRoute(
      builder: (context) => BlocProvider.value(
        value: BlocProvider.of<NameCubit>(blocContext),
        child: NameContainer(),
      ),
    ));
  }
}

class DashboardViewLazyI18N {
  final I18NMessages _messages;

  DashboardViewLazyI18N(this._messages);

  String? get transferencia => _messages.get("transferencia");

  String? get transaction_feed => _messages.get("transaction_feed");

  String? get alterar_nome => _messages.get("alterar_nome");
}

class _FeatureItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Function onClick;

  _FeatureItem(this.name, this.icon, {required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () {
            onClick();
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 32,
                ),
                Text(
                  name,
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
