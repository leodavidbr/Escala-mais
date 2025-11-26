import 'dart:async';
import 'route_repository.dart';
import '../models/route.dart';

/// In-memory implementation of RouteRepository.
/// Uses a StreamController to provide reactive updates.
/// This implementation can be easily replaced with a SQLite implementation later.
class InMemoryRouteRepository implements RouteRepository {
  final List<Route> _routes = [];
  final _streamController = StreamController<List<Route>>.broadcast();

  InMemoryRouteRepository() {
    // Emit initial empty list
    _streamController.add(List.unmodifiable(_routes));
  }

  @override
  Stream<List<Route>> getAllRoutes() {
    return _streamController.stream.map((routes) => List.unmodifiable(routes));
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

  /// Closes the stream controller. Should be called when the repository is disposed.
  void dispose() {
    _streamController.close();
  }
}

