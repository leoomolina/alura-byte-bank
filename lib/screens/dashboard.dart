import 'package:bytebank/components/byte_bank_app_bar.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/transactions_list.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ByteBankAppBar(
        context: context,
        title: 'Dashboard',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Image.asset('images/bytebank_logo.png')),
          ),
          Container(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FeatureItem(
                  'Transferências',
                  Icons.monetization_on,
                  onClick: () {
                    _mostrarListaContatos(context);
                  },
                ),
                _FeatureItem(
                  'Transaction Feed',
                  Icons.description,
                  onClick: () {
                    _mostrarListaTransacoes(context);
                  },
                ),
              ],
            ),
          ),
        ],
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