import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';

import 'http/webclient.dart';

void main() {
  runApp(ByteBankApp());
  findAll().then((transacoes) => print('Novas transações: $transacoes'));
}

class ByteBankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Dashboard(),
      theme: ThemeData(
        primaryColor: Colors.green[900],
        buttonTheme: ButtonThemeData(
            buttonColor: Colors.blueAccent[700],
            textTheme: ButtonTextTheme.primary),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
