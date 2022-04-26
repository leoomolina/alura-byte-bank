import 'package:bytebank/components/response_dialog.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String _message;

  const ErrorView(this._message);

  @override
  Widget build(BuildContext context) {
    return FailureDialog(_message);
  }
}
