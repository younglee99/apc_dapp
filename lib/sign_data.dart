import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SignatureDatabase {
  static const String dbName = 'signature.db';
  static const String tableName = 'signatures';

  late Database _database;

  Future<void> initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            signatureData TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertSignature(String signatureData) async {
    await _database.insert(tableName, {'signatureData': signatureData});
  }

  Future<List<String>> getAllSignatures() async {
    final List<Map<String, dynamic>> maps = await _database.query(tableName);

    return List.generate(maps.length, (i) {
      return maps[i]['signatureData'] as String;
    });
  }
}
