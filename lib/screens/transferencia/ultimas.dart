import 'package:bytebank/models/transferencias.dart';
import 'package:bytebank/screens/transferencia/lista.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UltimasTransferencias extends StatelessWidget {
  final _titulo = 'Últimas transferências:';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _titulo,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Consumer<Transferencias>(
          builder: ((context, transferencias, child) {
            final _ultimasTransferencias =
                transferencias.transferencias.reversed.toList();
            int _tamanho = transferencias.transferencias.length < 2
                ? transferencias.transferencias.length
                : 2;

            if (_tamanho == 0) return SemTransferenciaCadastrada();

            return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _tamanho,
                shrinkWrap: true,
                itemBuilder: (context, indice) {
                  return ItemTransferencia(_ultimasTransferencias[indice]);
                });
          }),
        )
      ],
    );
  }
}

class SemTransferenciaCadastrada extends StatelessWidget {
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(40),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          'Você ainda não cadastrou nenhuma transferência',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
