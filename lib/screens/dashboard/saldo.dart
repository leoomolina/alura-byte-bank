import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/saldo.dart';

class SaldoCard extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<Saldo>(builder: (context, valor, child) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            valor.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }
}
