import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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
  }

  /// Closes the database connection.
  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}

