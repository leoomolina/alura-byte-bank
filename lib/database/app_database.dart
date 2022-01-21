import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dao/contact_dao.dart';

Future<Database> getDatabase() async {
  // JOIN() => PEGAR STRING E JUNTAR A PARTIR DO SISTEMA QUE TIVER OPERANDO (ios, android, etc)
  final String path = join(await getDatabasesPath(), 'bytebank.db');

  return openDatabase(path, onCreate: (db, version) {
    db.execute(ContactDao.tableSql);
  }, version: 1, onDowngrade: onDatabaseDowngradeDelete);
}
