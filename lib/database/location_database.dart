// // lib/database/location_database.dart
import 'package:myapp/presentantion/screens/SettingScreen/models/stored_location.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';



import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocationDatabase {
  static final LocationDatabase instance = LocationDatabase._init();
  static Database? _database;

  LocationDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('locations.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE stored_locations(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      latitude REAL,
      longitude REAL,
      zone TEXT,
      easting REAL,
      northing REAL,
      isWGS84 INTEGER NOT NULL
    )
    ''');
  }

  Future<StoredLocation> create(StoredLocation location) async {
    final db = await instance.database;
    final id = await db.insert('stored_locations', location.toMap());
    return location.copyWith(id: id);
  }

  Future<List<StoredLocation>> getAllLocations() async {
    final db = await instance.database;
    final result = await db.query('stored_locations');
    return result.map((map) => StoredLocation.fromMap(map)).toList();
  }

  Future<void> deleteLocation(int id) async {
    final db = await instance.database;
    await db.delete(
      'stored_locations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

