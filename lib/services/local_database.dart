// services/local_database.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._internal();
  factory LocalDatabase() => _instance;
  LocalDatabase._internal();

  Database? _db;

  Future<Database> get db async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'birrawrapped.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE pending_beers (
            local_id    TEXT PRIMARY KEY,
            user_id     TEXT NOT NULL,
            beer_id     TEXT NOT NULL,
            date        TEXT NOT NULL,
            time        TEXT NOT NULL,
            day_of_week TEXT NOT NULL,
            synced      INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<void> insertPendingBeer(Map<String, dynamic> beer) async {
    final database = await db;
    await database.insert(
      'pending_beers',
      beer,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Map<String, dynamic>>> getPendingBeers() async {
    final database = await db;
    return database.query('pending_beers', where: 'synced = 0');
  }

  Future<void> markAsSynced(String localId) async {
    final database = await db;
    await database.update(
      'pending_beers',
      {'synced': 1},
      where: 'local_id = ?',
      whereArgs: [localId],
    );
  }
}
