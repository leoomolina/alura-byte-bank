import 'package:bytebank/models/contato.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  // JOIN() => PEGAR STRING E JUNTAR A PARTIR DO SISTEMA QUE TIVER OPERANDO (ios, android, etc)
  final String path = join(await getDatabasesPath(), 'bytebank.db');

  return openDatabase(path, onCreate: (db, version) {
    db.execute('CREATE TABLE contatos('
        'id INTEGER PRIMARY KEY, '
        'nome TEXT, '
        'numero_conta INTEGER)');
  }, version: 1, onDowngrade: onDatabaseDowngradeDelete);
}

Future<int> save(Contato contato) async {
  final Database db = await getDatabase();

  final Map<String, dynamic> contatoMap = Map();

  contatoMap['nome'] = contato.nome;
  contatoMap['numero_conta'] = contato.numeroConta;

  return db.insert('contatos', contatoMap);
}

Future<List<Contato>> findAll() async {
  final Database db = await getDatabase();

  final List<Map<String, Object?>> result = await db.query('contatos');
  final List<Contato> contatos = [];

  for (Map<String, dynamic> row in result) {
    final Contato contato =
        Contato(row['id'], row['nome'], row['numero_conta']);

    contatos.add(contato);
  }
  return contatos;
}
