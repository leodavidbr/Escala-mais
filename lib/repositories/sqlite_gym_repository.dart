import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'gym_repository.dart';
import '../models/gym.dart';
import '../services/database_service.dart';

/// SQLite implementation of GymRepository.
class SqliteGymRepository implements GymRepository {
  final _streamController = StreamController<List<Gym>>.broadcast();
  bool _isInitialized = false;
  final _initCompleter = Completer<void>();

  List<Gym> _cachedGyms = [];

  SqliteGymRepository() {
    _initialize();
  }

  Future<void> _initialize() async {
    if (_isInitialized) {
      await _initCompleter.future;
      return;
    }

    try {
      await DatabaseService.database;
      _isInitialized = true;
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }
      final gyms = await _loadAllGyms();
      _cachedGyms = gyms;
      _streamController.add(gyms);
    } catch (e) {
      if (!_initCompleter.isCompleted) {
        _initCompleter.completeError(e);
      }
      rethrow;
    }
  }

  /// Loads all gyms from the database.
  Future<List<Gym>> _loadAllGyms() async {
    final db = await DatabaseService.database;
    final maps = await db.query('gyms', orderBy: 'createdAt DESC');
    return maps.map((map) => _gymFromMap(map)).toList();
  }

  Gym _gymFromMap(Map<String, dynamic> map) {
    return Gym(
      id: map['id'] as String,
      name: map['name'] as String,
      location: map['location'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> _gymToMap(Gym gym) {
    return {
      'id': gym.id,
      'name': gym.name,
      'location': gym.location,
      'createdAt': gym.createdAt.toIso8601String(),
    };
  }

  @override
  Stream<List<Gym>> getAllGyms() async* {
    await _initialize();

    yield _cachedGyms;

    yield* _streamController.stream;
  }

  @override
  Future<Gym?> getGymById(String id) async {
    await _initialize();
    final db = await DatabaseService.database;
    final maps = await db.query(
      'gyms',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _gymFromMap(maps.first);
  }

  @override
  Future<void> createGym(Gym gym) async {
    await _initialize();
    final db = await DatabaseService.database;
    await db.insert(
      'gyms',
      _gymToMap(gym),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    final gyms = await _loadAllGyms();
    _cachedGyms = gyms;
    _streamController.add(gyms);
  }

  @override
  Future<bool> resetDatabase() async {
    try {
      await DatabaseService.resetDatabaseFile();

      final newGyms = await _loadAllGyms();
      _cachedGyms = newGyms;
      _streamController.add(newGyms);

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> deleteGym(String id) async {
    await _initialize();
    final db = await DatabaseService.database;
    final deletedCount = await db.delete(
      'gyms',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (deletedCount == 0) {
      throw Exception('Gym with id $id not found');
    }

    final gyms = await _loadAllGyms();
    _cachedGyms = gyms;
    _streamController.add(gyms);
  }

  void dispose() {
    _streamController.close();
  }
}
