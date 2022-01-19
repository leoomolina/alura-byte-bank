import 'package:bytebank/screens/contact_form.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text(
                'Leonardo',
                style: TextStyle(fontSize: 24),
              ),
              subtitle: Text(
                '1234',
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ContactForm()))
              .then((contato) => debugPrint(contato.toString()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
