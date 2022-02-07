import 'package:flutter/material.dart';

class TransactionAuthDialog extends StatelessWidget {
  const TransactionAuthDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Autenticação'),
      content: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
        obscureText: true,
        maxLength: 4,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 64, letterSpacing: 62),
      ),
      actions: [
        TextButton(
            onPressed: () {
              print('Cancelar');
            },
            child: Text('Cancelar')),
        TextButton(
            onPressed: () {
              print('confirm');
            },
            child: Text('Confirmar')),
      ],
    );
  }
}
