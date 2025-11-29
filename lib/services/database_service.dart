import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/route.dart';

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

  /// Initializes the database and creates tables if they don't exist.
  static Future<Database> _initDatabase() async {
    // Use getDatabasesPath() for better cross-platform compatibility
    // Falls back to getApplicationDocumentsDirectory() if needed
    String path;
    try {
      final directory = await getDatabasesPath();
      path = join(directory, _databaseName);
    } catch (e) {
      // Fallback to application documents directory
      final documentsDirectory = await getApplicationDocumentsDirectory();
      path = join(documentsDirectory.path, _databaseName);
    }

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  /// Creates the database tables.
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE routes (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        grade TEXT,
        photoPath TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        createdBy TEXT
      )
    ''');
    
    // Create index on createdAt for faster sorting
    await db.execute('''
      CREATE INDEX idx_routes_created_at ON routes(createdAt DESC)
    ''');
    
    // Seed initial mock data
    await _seedInitialData(db);
  }

  /// Seeds the database with initial mock routes.
  static Future<void> _seedInitialData(Database db) async {
    final mockRoutes = [
      Route(
        name: 'Paredão Leste',
        grade: 'v3',
        photoPath: 'assets/images/route1.jpeg',
      ),
      Route(
        name: 'Via do Sol',
        grade: 'v7',
        photoPath: 'assets/images/route2.jpeg',
      ),
      Route(
        name: 'Overhang Classic',
        grade: 'v1',
        photoPath: 'assets/images/route3.jpeg',
      ),
    ];

    final batch = db.batch();
    for (final route in mockRoutes) {
      batch.insert('routes', {
        'id': route.id,
        'name': route.name,
        'grade': route.grade,
        'photoPath': route.photoPath,
        'createdAt': route.createdAt.toIso8601String(),
        'createdBy': route.createdBy,
      });
    }
    await batch.commit(noResult: true);
  }

  /// Closes the database connection.
  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}

