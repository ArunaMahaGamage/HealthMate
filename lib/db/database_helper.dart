import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/health_entry.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('healthmate.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE health_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        steps INTEGER,
        calories INTEGER,
        water INTEGER
      )
    ''');
  }

  Future<int> insertEntry(HealthEntry entry) async {
    final db = await instance.database;
    return await db.insert('health_entries', entry.toMap());
  }

  Future<List<HealthEntry>> getAllEntries() async {
    final db = await instance.database;
    final result = await db.query('health_entries', orderBy: 'date DESC');
    return result.map((e) => HealthEntry.fromMap(e)).toList();
  }

  Future<int> updateEntry(HealthEntry entry) async {
    final db = await instance.database;
    return await db.update(
      'health_entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<int> deleteEntry(int id) async {
    final db = await instance.database;
    return await db.delete('health_entries', where: 'id = ?', whereArgs: [id]);
  }
}