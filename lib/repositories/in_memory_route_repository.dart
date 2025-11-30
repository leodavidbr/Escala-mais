// repositories/in_memory_route_repository.dart

import 'dart:async';
import 'route_repository.dart';
import '../models/route.dart';
import 'package:uuid/uuid.dart';

/// In-memory implementation of RouteRepository.
/// Uses a StreamController to provide reactive updates.
class InMemoryRouteRepository implements RouteRepository {
  final List<Route> _routes = [];
  final _streamController = StreamController<List<Route>>.broadcast();

  // ID Gym Mock
  final String _mockGymId = const Uuid().v4();

  InMemoryRouteRepository() {
    _seedInitialData();
  }

  /// Seeds the repository with initial mock routes.
  void _seedInitialData() {
    _routes.clear();
    _routes.addAll([
      Route(
        gymId: _mockGymId,
        name: 'Paredão Leste',
        grade: 'v3',
        photoPath: 'assets/images/route1.jpeg',
      ),
      Route(
        gymId: _mockGymId,
        name: 'Via do Sol',
        grade: 'v7',
        photoPath: 'assets/images/route2.jpeg',
      ),
      Route(
        gymId: _mockGymId,
        name: 'Overhang Classic',
        grade: 'v1',
        photoPath: 'assets/images/route3.jpeg',
      ),
    ]);

    _routes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Route> _filterRoutesByGymId(String gymId) {
    return _routes.where((route) => route.gymId == gymId).toList();
  }

  @override
  Stream<List<Route>> getRoutesByGymId(String gymId) async* {
    yield _filterRoutesByGymId(gymId);
    yield* _streamController.stream.map((_) => _filterRoutesByGymId(gymId));
  }

  @override
  Future<Route?> getRouteById(String id) async {
    try {
      return _routes.firstWhere((route) => route.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> createRoute(Route route) async {
    if (_routes.any((r) => r.id == route.id)) {
      throw Exception('Route with id ${route.id} already exists');
    }
    _routes.add(route);
    _routes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _streamController.add(_filterRoutesByGymId(route.gymId));
  }

  @override
  Future<void> deleteRoute(String id) async {
    final index = _routes.indexWhere((route) => route.id == id);
    if (index == -1) {
      throw Exception('Route with id $id not found');
    }
    final gymId = _routes[index].gymId;
    _routes.removeAt(index);
    _streamController.add(_filterRoutesByGymId(gymId));
  }

  @override
  Future<bool> resetDatabase() async {
    try {
      _seedInitialData();
      _streamController.add(_filterRoutesByGymId(_mockGymId));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Closes the stream controller. Should be called when the repository is disposed.
  void dispose() {
    _streamController.close();
  }
}
