import 'package:bytebank/components/centered_message.dart';
import 'package:bytebank/components/progress.dart';
import 'package:bytebank/http/webclient.dart';
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
      body: FutureBuilder<List<Transacao>>(
        future: findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Progress('Carregando');
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              final List<Transacao>? transacoes = snapshot.data;
              if (snapshot.hasData) {
                if (transacoes!.isNotEmpty) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final Transacao transacao = transacoes[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.monetization_on),
                          title: Text(
                            transacao.valor.toString(),
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            transacao.contato.numeroConta.toString(),
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: transacoes.length,
                  );
                }
              }
          }
          return CenteredMessage(
            'Nenhuma transação encontrada',
            icon: Icons.warning,
          );
        },
      ),
    );
  }
}
