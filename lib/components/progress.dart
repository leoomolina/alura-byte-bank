import 'package:flutter/material.dart';

import 'byte_bank_app_bar.dart';

class Progress extends StatelessWidget {
  final String message;

  const Progress(this.message);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              message,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ByteBankAppBar(
        context: context,
        title: 'Processando',
      ),
      body: Progress('Enviando...'),
    );
  }
}
