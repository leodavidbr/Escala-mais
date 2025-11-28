import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'route_repository.dart';
import '../models/route.dart';
import '../services/database_service.dart';

/// SQLite implementation of RouteRepository.
/// Persists routes to a local SQLite database.
class SqliteRouteRepository implements RouteRepository {
  final _streamController = StreamController<List<Route>>.broadcast();
  bool _isInitialized = false;
  final _initCompleter = Completer<void>();

  SqliteRouteRepository() {
    _initialize();
  }

  /// Initializes the repository and loads initial data.
  Future<void> _initialize() async {
    if (_isInitialized) {
      await _initCompleter.future;
      return;
    }
    
    try {
      // Ensure database is initialized
      await DatabaseService.database;
      _isInitialized = true;
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }
    } catch (e) {
      if (!_initCompleter.isCompleted) {
        _initCompleter.completeError(e);
      }
      rethrow;
    }
  }

  /// Loads all routes from the database.
  Future<List<Route>> _loadAllRoutes() async {
    final db = await DatabaseService.database;
    final maps = await db.query(
      'routes',
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => _routeFromMap(map)).toList();
  }

  /// Converts a database map to a Route object.
  Route _routeFromMap(Map<String, dynamic> map) {
    try {
      return Route(
        id: map['id'] as String,
        name: map['name'] as String,
        grade: map['grade'] as String?,
        photoPath: map['photoPath'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
        createdBy: map['createdBy'] as String?,
      );
    } catch (e) {
      throw FormatException(
        'Failed to parse route from database: $e',
        map,
      );
    }
  }

  /// Converts a Route object to a database map.
  Map<String, dynamic> _routeToMap(Route route) {
    return {
      'id': route.id,
      'name': route.name,
      'grade': route.grade,
      'photoPath': route.photoPath,
      'createdAt': route.createdAt.toIso8601String(),
      'createdBy': route.createdBy,
    };
  }

  @override
  Stream<List<Route>> getAllRoutes() async* {
    try {
      await _initialize();
      // Emit current state immediately
      final routes = await _loadAllRoutes();
      yield routes;
      
      // Then listen for updates from the stream controller
      yield* _streamController.stream;
    } catch (e) {
      // Emit empty list on error to prevent stream from failing
      yield [];
      // Continue listening for updates even after error
      yield* _streamController.stream;
    }
  }

  @override
  Future<Route?> getRouteById(String id) async {
    await _initialize();
    try {
      final db = await DatabaseService.database;
      final maps = await db.query(
        'routes',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isEmpty) return null;
      return _routeFromMap(maps.first);
    } catch (e) {
      throw Exception('Failed to get route by id: $e');
    }
  }

  @override
  Future<void> createRoute(Route route) async {
    await _initialize();
    try {
      final db = await DatabaseService.database;

      await db.insert(
        'routes',
        _routeToMap(route),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );

      // Emit updated list
      final routes = await _loadAllRoutes();
      _streamController.add(routes);
    } on DatabaseException catch (e) {
      // Handle unique constraint violation (duplicate ID)
      if (e.toString().contains('UNIQUE constraint') ||
          e.toString().contains('PRIMARY KEY')) {
        throw Exception('Route with id ${route.id} already exists');
      }
      rethrow;
    } catch (e) {
      throw Exception('Failed to create route: $e');
    }
  }

  @override
  Future<void> deleteRoute(String id) async {
    await _initialize();
    try {
      final db = await DatabaseService.database;

      final deletedCount = await db.delete(
        'routes',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (deletedCount == 0) {
        throw Exception('Route with id $id not found');
      }

      // Emit updated list
      final routes = await _loadAllRoutes();
      _streamController.add(routes);
    } catch (e) {
      if (e.toString().contains('not found')) {
        rethrow;
      }
      throw Exception('Failed to delete route: $e');
    }
  }

  /// Closes the stream controller. Should be called when the repository is disposed.
  void dispose() {
    _streamController.close();
  }
}

