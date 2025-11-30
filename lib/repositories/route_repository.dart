import '../models/route.dart';

/// Abstract interface for route data storage.
abstract class RouteRepository {
  /// Returns a stream of all routes for a specific gym.
  Stream<List<Route>> getRoutesByGymId(String gymId);

  /// Retrieves a route by its ID.
  Future<Route?> getRouteById(String id);

  /// Creates a new route.
  Future<void> createRoute(Route route);

  /// Deletes a route by its ID.
  Future<void> deleteRoute(String id);

  /// Deletes and recreates the database, returning it to the initial state.
  Future<bool> resetDatabase();
}
