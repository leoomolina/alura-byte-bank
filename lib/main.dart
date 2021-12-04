import 'package:flutter/material.dart';

void main() => runApp(ByteBankApp());

class ByteBankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListaTransferencias(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FormularioTransferencia extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormularioTransferenciaState();
  }
}

class FormularioTransferenciaState extends State<FormularioTransferencia> {
  final TextEditingController _controllerCampoNumeroConta =
      TextEditingController();
  final TextEditingController _controllerCampoValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrando transferência'),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Editor(
              controlador: _controllerCampoNumeroConta,
              rotulo: 'Número da Conta',
              dica: '0000'),
          Editor(
              controlador: _controllerCampoValor,
              rotulo: 'Valor',
              dica: '0.00',
              icone: Icons.monetization_on),
          ElevatedButton(
            onPressed: () => _criaTransferencia(context),
            child: Text('Confimar'),
          )
        ]),
      ),
    );
  }

  void _criaTransferencia(BuildContext context) {
    final String numeroConta = _controllerCampoNumeroConta.text;
    final double? valor = double.tryParse(_controllerCampoValor.text);
    if (numeroConta != '' && valor != null) {
      final transferenciaCriada = Transferencia(valor, numeroConta);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transferência gravada com sucesso!'),
        ),
      );
      Navigator.pop(context, transferenciaCriada);
    }
  }
}

class Editor extends StatelessWidget {
  final TextEditingController? controlador;
  final String? rotulo;
  final String? dica;
  final IconData? icone;

  const Editor({this.controlador, this.rotulo, this.dica, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        style: TextStyle(fontSize: 24.0),
        decoration: InputDecoration(
          icon: icone != null ? Icon(icone) : null,
          labelText: rotulo,
          hintText: dica,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}

class ListaTransferencias extends StatefulWidget {
  final List<Transferencia> _transferencias = [];

  @override
  State<StatefulWidget> createState() {
    return ListaTransferenciasState();
  }
}

class ListaTransferenciasState extends State<ListaTransferencias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transferências'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: widget._transferencias.length,
        itemBuilder: (context, indice) {
          final _transferencia = widget._transferencias[indice];
          return ItemTransferencia(_transferencia);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Future<Transferencia?> future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioTransferencia();
          }));
          future.then((transferenciaRecebida) {
            Future.delayed(Duration(seconds: 1), () {
              if (transferenciaRecebida != null) {
                setState(() {
                  widget._transferencias.add(transferenciaRecebida);
                });
              }
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(_transferencia.valor.toString()),
        subtitle: Text(_transferencia.numeroConta),
      ),
    );
  }
}

class Transferencia {
  final double valor;
  final String numeroConta;

  Transferencia(this.valor, this.numeroConta);

  @override
  String toString() {
    return 'Numero Conta: ' + numeroConta + ' / ' + valor.toString();
  }
}
