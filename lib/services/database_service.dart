// services/database_service.dart

import 'package:escala_mais/core/logging/app_logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/route.dart';
import '../models/gym.dart';

/// Service for managing the SQLite database.
class DatabaseService {
  static const String _databaseName = 'escala_mais.db';
  static const int _databaseVersion = 1;

  static Database? _database;

  /// Gets the database instance, creating it if necessary.
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Deletes the database file and reinitializes it.
  static Future<void> resetDatabaseFile() async {
    logWarning('Resetting database file');
    await close();
    String path;
    try {
      final directory = await getDatabasesPath();
      path = join(directory, _databaseName);
    } catch (e) {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      path = join(documentsDirectory.path, _databaseName);
    }

    await deleteDatabase(path);
    logInfo('Database file deleted', {'path': path});
    _database = await _initDatabase();
  }

  /// Initializes the database and creates tables if they don't exist.
  static Future<Database> _initDatabase() async {
    // Use getDatabasesPath() for better cross-platform compatibility
    String path;
    try {
      final directory = await getDatabasesPath();
      path = join(directory, _databaseName);
      logDebug('Using databases path for SQLite file', {
        'directory': directory,
        'path': path,
      });
    } catch (e, stackTrace) {
      // Fallback to application documents directory
      final documentsDirectory = await getApplicationDocumentsDirectory();
      path = join(documentsDirectory.path, _databaseName);
      logWarning(
        'Failed to get databases path, falling back to documents directory',
        e,
        stackTrace,
      );
    }

    logInfo('Opening SQLite database', {
      'path': path,
      'version': _databaseVersion,
    });

    final db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );

    logInfo('SQLite database opened successfully');
    return db;
  }

  /// Creates the database tables.
  static Future<void> _onCreate(Database db, int version) async {
    logInfo('Creating database schema', {'version': version});
    await db.execute('''
 CREATE TABLE gyms (
 id TEXT PRIMARY KEY,
 name TEXT NOT NULL,
 location TEXT,
 createdAt TEXT NOT NULL
 )
 ''');

    await db.execute('''
  CREATE TABLE routes (
  id TEXT PRIMARY KEY,
  gymId TEXT NOT NULL, 
  name TEXT NOT NULL,
  grade TEXT,
  photoPath TEXT NOT NULL,
  createdAt TEXT NOT NULL,
  createdBy TEXT,
  FOREIGN KEY (gymId) REFERENCES gyms (id) ON DELETE CASCADE
  )
 ''');

    await db.execute('''
  CREATE INDEX idx_routes_created_at ON routes(createdAt DESC)
 ''');

    await _seedInitialData(db);
  }

  /// Seeds the database with initial mock routes and one gym.
  static Future<void> _seedInitialData(Database db) async {
    final defaultGym = Gym(
      name: 'Academia Local (Mock)',
      location: 'São Paulo, SP',
    );

    await db.insert('gyms', {
      'id': defaultGym.id,
      'name': defaultGym.name,
      'location': defaultGym.location,
      'createdAt': defaultGym.createdAt.toIso8601String(),
    });

    final mockRoutes = [
      Route(
        gymId: defaultGym.id,
        name: 'Paredão Leste',
        grade: 'v3',
        photoPath: 'assets/images/route1.jpeg',
      ),
      Route(
        gymId: defaultGym.id,
        name: 'Via do Sol',
        grade: 'v7',
        photoPath: 'assets/images/route2.jpeg',
      ),
      Route(
        gymId: defaultGym.id,
        name: 'Overhang Classic',
        grade: 'v1',
        photoPath: 'assets/images/route3.jpeg',
      ),
    ];

    final batch = db.batch();
    for (final route in mockRoutes) {
      batch.insert('routes', {
        'id': route.id,
        'gymId': route.gymId,
        'name': route.name,
        'grade': route.grade,
        'photoPath': route.photoPath,
        'createdAt': route.createdAt.toIso8601String(),
        'createdBy': route.createdBy,
      });
    }
    await batch.commit(noResult: true);

    logInfo('Seeded initial data', {
      'gymId': defaultGym.id,
      'gymName': defaultGym.name,
      'routesCount': mockRoutes.length,
    });
  }

  /// Closes the database connection.
  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
