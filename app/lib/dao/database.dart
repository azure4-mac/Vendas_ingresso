import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  DatabaseProvider._privateConstructor();

  static final DatabaseProvider instance =
      DatabaseProvider._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'ticket_app.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        ticketQuantidade INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        compradorNome TEXT NOT NULL,
        compradorNasc TEXT NOT NULL,
        quantidadeVendida INTEGER NOT NULL,
        eventId INTEGER NOT NULL,
        FOREIGN KEY (eventId) REFERENCES events (id)
      )
    ''');
  }
}
