import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/container.dart';
import '../../models/name.dart';
import '../name.dart';
import 'dashboard_feature_item.dart';
import 'dashboard_i18n.dart';

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
                  FeatureItem(
                    _i18n.transferencia!,
                    Icons.monetization_on,
                    onClick: () {
                      _mostrarListaContatos(context);
                    },
                  ),
                  FeatureItem(
                    _i18n.transaction_feed!,
                    Icons.description,
                    onClick: () {
                      _mostrarListaTransacoes(context);
                    },
                  ),
                  FeatureItem(
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
