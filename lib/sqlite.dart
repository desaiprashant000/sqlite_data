import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class mydatabase {
  Future<Database> creatdb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    print(path);

    Database database = await openDatabase(
      path,
      version: 9,
      onUpgrade: (db, oldversion, newversion) async {
        await db.execute('alter TABLE contact add favorite integer default 0');
      },
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE contact (id INTEGER PRIMARY KEY, name TEXT, contact TEXT, email TEXT)');
      },
    );

    return database;
  }
}
