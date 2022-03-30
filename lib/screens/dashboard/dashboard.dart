import 'package:bytebank/components/byte_bank_app_bar.dart';
import 'package:bytebank/screens/dashboard/saldo.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/transactions_list.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ByteBankAppBar(
        context: context,
        title: 'ByteBank',
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SaldoCard(),
      ),
    );
  }

  void _mostrarListaContatos(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ContactsList(),
    ));
  }

  void _mostrarListaTransacoes(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TransactionsList(),
    ));
  }
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
