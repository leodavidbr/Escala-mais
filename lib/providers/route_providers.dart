import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/route.dart';
import '../repositories/route_repository.dart';
import '../repositories/sqlite_route_repository.dart';
import '../services/image_service.dart';
import '../services/storage_service.dart';

/// Provides the route repository instance.
/// Uses SQLite for persistent storage.
final routeRepositoryProvider = Provider<RouteRepository>((ref) {
  final repository = SqliteRouteRepository();
  // Dispose the repository when the provider is disposed
  ref.onDispose(() {
    repository.dispose();
  });
  return repository;
});

/// Provides the image service instance.
final imageServiceProvider = Provider<ImageService>((ref) {
  return ImageService();
});

/// Provides the storage service instance.
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

/// Stream provider that provides all routes.
/// Automatically updates when routes are added, removed, or modified.
final routesProvider = StreamProvider<List<Route>>((ref) {
  final repository = ref.watch(routeRepositoryProvider);
  return repository.getAllRoutes();
});

/// Future provider that provides a single route by ID.
final routeProvider = FutureProvider.family<Route?, String>((ref, routeId) async {
  final repository = ref.watch(routeRepositoryProvider);
  return repository.getRouteById(routeId);
});

/// State for route creation.
class CreateRouteState {
  final bool isLoading;
  final String? error;
  final Route? createdRoute;

  CreateRouteState({
    this.isLoading = false,
    this.error,
    this.createdRoute,
  });

  CreateRouteState copyWith({
    bool? isLoading,
    String? error,
    Route? createdRoute,
  }) {
    return CreateRouteState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      createdRoute: createdRoute ?? this.createdRoute,
    );
  }
}

/// StateNotifier for managing route creation.
class CreateRouteNotifier extends StateNotifier<CreateRouteState> {
  CreateRouteNotifier(this.ref) : super(CreateRouteState());

  final Ref ref;

  Future<void> createRoute({
    required String name,
    String? grade,
    required String photoPath,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(routeRepositoryProvider);
      final route = Route(
        name: name,
        grade: grade,
        photoPath: photoPath,
      );

      await repository.createRoute(route);
      state = state.copyWith(
        isLoading: false,
        createdRoute: route,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void reset() {
    state = CreateRouteState();
  }
}

/// Provider for route creation state management.
final createRouteProvider =
    StateNotifierProvider<CreateRouteNotifier, CreateRouteState>((ref) {
  return CreateRouteNotifier(ref);
});

