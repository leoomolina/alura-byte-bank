import 'package:bytebank/database/app_database.dart';
import 'package:bytebank/models/contato.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ContactDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_nome TEXT, '
      '$_numeroConta INTEGER)';

  static const String _tableName = 'contatos';

  static const String _id = 'id';
  static const String _nome = 'nome';
  static const String _numeroConta = 'numero_conta';

  Future<int> save(Contato contato) async {
    final Database db = await getDatabase();

    return db.insert(_tableName, _toMap(contato, db));
  }

  Future<void> update(Contato contato) async {
    // Get a reference to the database.
    final db = await getDatabase();

    // Update the given Dog.
    await db.update(
      _tableName,
      _toMap(contato, db),
      where: '$_id = ?',
      whereArgs: [contato.id],
    );
  }

  Future<void> remove(int id) async {
    final Database db = await getDatabase();

    // Remove the Dog from the database.
    await db.delete(
      _tableName,
      // Use a `where` clause to delete a specific dog.
      where: '$_id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> findById(int id) async {
    final Database db = await getDatabase();

    List<String> columnsToSelect = [
      _id,
      _nome,
      _numeroConta,
    ];

    List<dynamic> whereArguments = [_id];

    final List<Map> result = await db.query(_tableName,
        columns: columnsToSelect, whereArgs: whereArguments);

    result.forEach((row) => debugPrint(row.toString()));
  }

  Future<List<Contato>> findAll() async {
    final Database db = await getDatabase();

    final List<Map<String, Object?>> result = await db.query(_tableName);
    return _toList(result);
  }

  List<Contato> _toList(List<Map<String, Object?>> result) {
    final List<Contato> contatos = [];

    for (Map<String, dynamic> row in result) {
      final Contato contato = Contato(row[_id], row[_nome], row[_numeroConta]);

      contatos.add(contato);
    }
    return contatos;
  }

  Map<String, dynamic> _toMap(Contato contato, Database db) {
    final Map<String, dynamic> contatoMap = Map();

    contatoMap[_nome] = contato.nome;
    contatoMap[_numeroConta] = contato.numeroConta;

    //return db.insert(_tableName, contatoMap);
    return contatoMap;
  }
}
