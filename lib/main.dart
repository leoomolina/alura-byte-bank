import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';

import 'components/transaction_auth_dialog.dart';

void main() {
  runApp(ByteBankApp());
}

class ByteBankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TransactionAuthDialog(),
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
