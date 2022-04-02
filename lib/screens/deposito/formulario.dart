import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/editor.dart';
import '../../models/saldo.dart';

const _tituloAppBar = 'Receber depósito';

const _rotuloCampoValor = 'Valor';
const _dicaCampoValor = '0.00';

const _textoBotaoConfirmar = 'Confirmar';

class FormularioDeposito extends StatelessWidget {
  final TextEditingController _controllerCampoValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_tituloAppBar),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Editor(
              controlador: _controllerCampoValor,
              rotulo: _rotuloCampoValor,
              dica: _dicaCampoValor,
              icone: Icons.monetization_on),
          ElevatedButton(
            onPressed: () => _criaDeposito(context),
            child: Text(_textoBotaoConfirmar),
          )
        ]),
      ),
    );
  }

  _criaDeposito(context) {
    final double? valor = double.tryParse(_controllerCampoValor.text);

    if (_validaDeposito(valor)) {
      _atualizaEstado(context, valor);
      Navigator.of(context).pop();
    }
  }

  _validaDeposito(valor) {
    final campoPreenchido = valor != null;
    return campoPreenchido;
  }

  _atualizaEstado(context, valor) {
    Provider.of<Saldo>(context, listen: false).adiciona(valor);
  }
}
