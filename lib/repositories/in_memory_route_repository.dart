// repositories/in_memory_route_repository.dart

import 'dart:async';
import 'route_repository.dart';
import '../models/route.dart';

/// In-memory implementation of RouteRepository.
/// Uses a StreamController to provide reactive updates.
class InMemoryRouteRepository implements RouteRepository {
  final List<Route> _routes = [];
  final _streamController = StreamController<List<Route>>.broadcast();

  InMemoryRouteRepository() {
    _seedInitialData();
  }

  /// Seeds the repository with initial mock routes.
  void _seedInitialData() {
    _routes.clear();
    _routes.addAll([
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
    ]);

    _routes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (!_streamController.isClosed) {
      _streamController.add(List.unmodifiable(_routes));
    }
  }

  @override
  Stream<List<Route>> getAllRoutes() async* {
    yield List.unmodifiable(_routes);
    yield* _streamController.stream.map((routes) => List.unmodifiable(routes));
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
    _streamController.add(List.unmodifiable(_routes));
  }

  @override
  Future<void> deleteRoute(String id) async {
    final index = _routes.indexWhere((route) => route.id == id);
    if (index == -1) {
      throw Exception('Route with id $id not found');
    }
    _routes.removeAt(index);
    _streamController.add(List.unmodifiable(_routes));
  }

  @override
  Future<bool> resetDatabase() async {
    try {
      _seedInitialData();
      _streamController.add(List.unmodifiable(_routes));
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
