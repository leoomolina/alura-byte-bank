import 'package:bytebank/components/byte_bank_app_bar.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String _message;

  const ErrorView(this._message);

  @override
  Widget build(BuildContext context) {
    //Toast.show(message, context, gravity: Toast.BOTTOM);

    /*return showDialog(
      context: context,
      builder: (_) => NetworkGiffyDialog(
        image: Image.asset('images/error.gif'),
        title: Text('OPS',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
        description: Text(
          message,
          textAlign: TextAlign.center,
        ),
        entryAnimation: EntryAnimation.TOP,
      ),
    );*/
    return Scaffold(
      appBar: ByteBankAppBar(context: context, title: "Erro"),
      body: Text(_message),
    );
  }
}
