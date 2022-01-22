import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/models/contato.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatefulWidget {
  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final ContactDao _dao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
      ),
      body: FutureBuilder<List<Contato>>(
        initialData: [],
        future: _dao.findAll(),
        builder: (context, snapshot) {
          final List<Contato>? contatos = snapshot.data;

          return ListView.builder(
            itemBuilder: (context, index) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  break;
                case ConnectionState.waiting:
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Text('Carregando')
                      ],
                    ),
                  );
                case ConnectionState.active:
                  break;
                case ConnectionState.done:
                  final Contato contato = contatos![index];

                  return _ContatoItem(contato);
              }
              return Text('unknow error');
            },
            itemCount: contatos!.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ContactForm()))
              .then((value) => setState(() {}));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _ContatoItem extends StatefulWidget {
  final Contato contato;
  _ContatoItem(this.contato);

  @override
  State<_ContatoItem> createState() => _ContatoItemState();
}

class _ContatoItemState extends State<_ContatoItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          widget.contato.nome,
          style: TextStyle(fontSize: 24),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          color: Colors.orange,
          iconSize: 32,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => ContactForm(contato: widget.contato)))
                .then((value) => setState(() {}));
          },
        ),
        subtitle: Text(
          widget.contato.numeroConta.toString(),
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
