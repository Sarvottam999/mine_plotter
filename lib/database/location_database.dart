// lib/database/location_database.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocationDatabase {
  static Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    return await openDatabase(
      join(path, 'locations_database.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE locations(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            display_name TEXT,
            lat REAL,
            lon REAL,
            type TEXT,
            region TEXT,
            search_terms TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> addLocation(Map<String, dynamic> location) async {
    final db = await database;
    
    // Create search terms for better searching
    String searchTerms = [
      location['display_name'],
      location['type'],
      location['region'],
    ].where((term) => term != null).join(' ').toLowerCase();

    await db.insert(
      'locations',
      {
        'display_name': location['display_name'],
        'lat': location['lat'],
        'lon': location['lon'],
        'type': location['type'] ?? 'unknown',
        'region': location['region'] ?? 'unknown',
        'search_terms': searchTerms,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> searchLocations(String query) async {
    final db = await database;
    final searchTerm = query.toLowerCase();
    
    return await db.query(
      'locations',
      where: 'search_terms LIKE ?',
      whereArgs: ['%$searchTerm%'],
      orderBy: 'display_name ASC',
      limit: 10,
    );
  }

  Future<List<Map<String, dynamic>>> getLocationsByRegion(String region) async {
    final db = await database;
    return await db.query(
      'locations',
      where: 'region = ?',
      whereArgs: [region],
      orderBy: 'display_name ASC',
    );
  }

  Future<void> clearAllLocations() async {
    final db = await database;
    await db.delete('locations');
  }

  Future<int> getLocationCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM locations');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<bool> locationExists(String displayName) async {
    final db = await database;
    final result = await db.query(
      'locations',
      where: 'display_name = ?',
      whereArgs: [displayName],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}