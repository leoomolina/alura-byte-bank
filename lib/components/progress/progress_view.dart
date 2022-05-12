import 'package:bytebank/components/progress/progress.dart';
import 'package:flutter/material.dart';
import '../byte_bank_app_bar.dart';

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
