import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/models/contato.dart';
import 'package:flutter/material.dart';

class ContactForm extends StatefulWidget {
  ContactForm({this.contato});
  final Contato? contato;

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final ContactDao _dao = ContactDao();

  String textTitle = 'Novo contato';
  String textButton = 'Gravar';

  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _numeroContaController = TextEditingController();

    if (widget.contato != null) {
      _nameController = new TextEditingController(text: widget.contato!.nome);
      _numeroContaController = new TextEditingController(
          text: widget.contato!.numeroConta.toString());

      textTitle = 'Editar contato';
      textButton = 'Atualizar';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(textTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nome',
              ),
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _numeroContaController,
                decoration: InputDecoration(
                  labelText: 'Número da conta',
                ),
                style: TextStyle(
                  fontSize: 24.0,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  child: Text(textButton),
                  onPressed: () {
                    final String name = _nameController.text;
                    final int? numConta =
                        int.tryParse(_numeroContaController.text);

                    if (widget.contato != null) {
                      final contato =
                          new Contato(widget.contato!.id, name, numConta);

                      _dao
                          .update(contato)
                          .then((value) => Navigator.pop(context));
                    } else {
                      final contato = new Contato(0, name, numConta);

                      _dao.save(contato).then((id) => Navigator.pop(context));
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
