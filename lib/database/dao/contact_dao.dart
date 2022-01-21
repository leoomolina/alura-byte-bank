import 'package:bytebank/database/app_database.dart';
import 'package:bytebank/models/contato.dart';
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

    return _toMap(contato, db);
  }

  Future<int> _toMap(Contato contato, Database db) {
    final Map<String, dynamic> contatoMap = Map();

    contatoMap[_nome] = contato.nome;
    contatoMap[_numeroConta] = contato.numeroConta;

    return db.insert(_tableName, contatoMap);
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
}
