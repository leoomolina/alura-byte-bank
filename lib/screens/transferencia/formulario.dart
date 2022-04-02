import 'package:bytebank/components/byte_bank_app_bar.dart';
import 'package:bytebank/components/editor.dart';
import 'package:bytebank/models/transferencia.dart';
import 'package:bytebank/models/transferencias.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/saldo.dart';

const _tituloAppBar = 'Cadastrando tsransferência';

const _rotuloCampoNumeroConta = 'Número da Conta';
const _dicaCampoNumeroConta = '0000';

const _rotuloCampoValor = 'Valor';
const _dicaCampoValor = '0.00';

const _textoBotaoConfirmar = 'Confirmar';
const _msgGravadoSucesso = 'Transferência gravada com sucesso!';

class FormularioTransferencia extends StatelessWidget {
  final TextEditingController _controllerCampoNumeroConta =
      TextEditingController();
  final TextEditingController _controllerCampoValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ByteBankAppBar(
        context: context,
        title: _tituloAppBar,
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Editor(
              controlador: _controllerCampoNumeroConta,
              rotulo: _rotuloCampoNumeroConta,
              dica: _dicaCampoNumeroConta),
          Editor(
              controlador: _controllerCampoValor,
              rotulo: _rotuloCampoValor,
              dica: _dicaCampoValor,
              icone: Icons.monetization_on),
          ElevatedButton(
            onPressed: () => _criaTransferencia(context),
            child: Text(_textoBotaoConfirmar),
          )
        ]),
      ),
    );
  }

  void _criaTransferencia(BuildContext context) {
    final String numeroConta = _controllerCampoNumeroConta.text;
    final double? valor = double.tryParse(_controllerCampoValor.text);
    if (_validaTransferencia(context, numeroConta, valor)) {
      final novaTransferencia = Transferencia(valor!, numeroConta);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_msgGravadoSucesso),
        ),
      );

      _atualizaEstado(context, novaTransferencia, valor);

      Navigator.pop(context);
    }
  }

  _validaTransferencia(context, numeroConta, valor) {
    final campoPreenchido = numeroConta != '' && valor != null;
    final _saldoSuficiente =
        valor <= Provider.of<Saldo>(context, listen: false).valor;
    return campoPreenchido && _saldoSuficiente;
  }

  _atualizaEstado(context, novaTransferencia, valor) {
    Provider.of<Transferencias>(context, listen: false)
        .adiciona(novaTransferencia);

    Provider.of<Saldo>(context, listen: false).subtrai(valor);
  }
}
