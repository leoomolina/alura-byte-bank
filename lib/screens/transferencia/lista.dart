import 'package:bytebank/components/byte_bank_app_bar.dart';
import 'package:bytebank/models/transferencia.dart';
import 'package:bytebank/screens/transferencia/formulario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/transferencias.dart';

const _tituloAppBar = 'Transferências';

class ListaTransferencias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ByteBankAppBar(
        context: context,
        title: _tituloAppBar,
      ),
      body: Consumer<Transferencias>(
        builder: ((context, transferencia, child) {
          return ListView.builder(
            itemCount: transferencia.transferencias.length,
            itemBuilder: (context, indice) {
              final _transferencia = transferencia.transferencias[indice];
              return ItemTransferencia(_transferencia);
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioTransferencia();
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(_transferencia.toStringValor()),
        subtitle: Text(_transferencia.toStringNumeroConta()),
        // trailing: Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: <Widget>[
        //     IconButton(
        //       onPressed: () {},
        //       icon: Icon(
        //         Icons.edit,
        //         color: Colors.yellow[800],
        //       ),
        //     ),
        //     IconButton(
        //       onPressed: () {
        //         ScaffoldMessenger.of(context).showSnackBar(
        //           SnackBar(
        //             content: Text(_msgRemovidoSucesso),
        //           ),
        //         );
        //       },
        //       icon: Icon(
        //         Icons.delete,
        //         color: Colors.red,
        //       ),
        //     )
        //   ],
        // ),
      ),
    );
  }
}
