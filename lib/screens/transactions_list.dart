import 'package:bytebank/models/transacao.dart';
import 'package:flutter/material.dart';

class TransactionsList extends StatelessWidget {
  final List<Transacao> transactions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final Transacao transaction = transactions[index];
          return Card(
            child: ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text(
                transaction.valor.toString(),
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                transaction.contato.numeroConta.toString(),
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          );
        },
        itemCount: transactions.length,
      ),
    );
  }
}
