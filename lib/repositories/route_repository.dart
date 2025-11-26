import '../models/route.dart';

/// Abstract interface for route data storage.
/// This allows easy swapping between in-memory and SQLite implementations.
abstract class RouteRepository {
  /// Returns a stream of all routes.
  /// The stream will emit updates whenever routes are added, removed, or modified.
  Stream<List<Route>> getAllRoutes();

  /// Retrieves a route by its ID.
  /// Returns null if the route doesn't exist.
  Future<Route?> getRouteById(String id);

  /// Creates a new route.
  /// Throws an exception if the route cannot be created.
  Future<void> createRoute(Route route);

  /// Deletes a route by its ID.
  /// Throws an exception if the route doesn't exist or cannot be deleted.
  Future<void> deleteRoute(String id);
}

