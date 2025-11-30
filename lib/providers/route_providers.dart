import 'package:escala_mais/models/gym.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/route.dart';
import '../repositories/route_repository.dart';
import '../repositories/sqlite_route_repository.dart';
import '../services/image_service.dart';
import '../services/storage_service.dart';
import '../repositories/gym_repository.dart';
import '../repositories/sqlite_gym_repository.dart';

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

/// Provides the Gym repository instance.
final gymRepositoryProvider = Provider<GymRepository>((ref) {
  final repository = SqliteGymRepository();
  ref.onDispose(() {
    (repository).dispose();
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

/// Stream provider that provides all gyms.
final gymsProvider = StreamProvider<List<Gym>>((ref) {
  final repository = ref.watch(gymRepositoryProvider);
  return repository.getAllGyms();
});

/// Future provider that provides a single gym by ID.
final gymProvider = FutureProvider.family<Gym?, String>((ref, gymId) async {
  final repository = ref.watch(gymRepositoryProvider);
  return repository.getGymById(gymId);
});

/// Stream provider that provides all routes.
/// Automatically updates when routes are added, removed, or modified.
final routesProvider = StreamProvider.family<List<Route>, String>((ref, gymId) {
  final repository = ref.watch(routeRepositoryProvider);
  return repository.getRoutesByGymId(gymId);
});

/// Future provider that provides a single route by ID.
final routeProvider = FutureProvider.family<Route?, String>((
  ref,
  routeId,
) async {
  final repository = ref.watch(routeRepositoryProvider);
  return repository.getRouteById(routeId);
});

/// State for route creation.
class CreateRouteState {
  final bool isLoading;
  final String? error;
  final Route? createdRoute;

  CreateRouteState({this.isLoading = false, this.error, this.createdRoute});

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
    required String gymId,
    required String name,
    String? grade,
    required String photoPath,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(routeRepositoryProvider);
      final route = Route(
        gymId: gymId,
        name: name,
        grade: grade,
        photoPath: photoPath,
      );

      await repository.createRoute(route);
      state = state.copyWith(isLoading: false, createdRoute: route);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
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

class CreateGymState {
  final bool isLoading;
  final String? error;
  final Gym? createdGym;

  CreateGymState({this.isLoading = false, this.error, this.createdGym});

  CreateGymState copyWith({bool? isLoading, String? error, Gym? createdGym}) {
    return CreateGymState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      createdGym: createdGym ?? this.createdGym,
    );
  }
}

class CreateGymNotifier extends StateNotifier<CreateGymState> {
  CreateGymNotifier(this.ref) : super(CreateGymState());

  final Ref ref;

  Future<void> createGym({required String name, String? location}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(gymRepositoryProvider);
      final gym = Gym(name: name, location: location);

      await repository.createGym(gym);
      state = state.copyWith(isLoading: false, createdGym: gym);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void reset() {
    state = CreateGymState();
  }
}

final createGymProvider =
    StateNotifierProvider<CreateGymNotifier, CreateGymState>((ref) {
      return CreateGymNotifier(ref);
    });

class DeleteRouteState {
  final bool isLoading;
  final String? error;
  final bool isDeleted;

  DeleteRouteState({this.isLoading = false, this.error, this.isDeleted = false});

  DeleteRouteState copyWith({bool? isLoading, String? error, bool? isDeleted}) {
    return DeleteRouteState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

class DeleteRouteNotifier extends StateNotifier<DeleteRouteState> {
  DeleteRouteNotifier(this.ref) : super(DeleteRouteState());

  final Ref ref;

  Future<void> deleteRoute(String routeId) async {
    state = state.copyWith(isLoading: true, error: null, isDeleted: false);

    try {
      final repository = ref.read(routeRepositoryProvider);
      await repository.deleteRoute(routeId);
      state = state.copyWith(isLoading: false, isDeleted: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void reset() {
    state = DeleteRouteState();
  }
}

final deleteRouteProvider =
    StateNotifierProvider<DeleteRouteNotifier, DeleteRouteState>((ref) {
      return DeleteRouteNotifier(ref);
    });

class DeleteGymState {
  final bool isLoading;
  final String? error;
  final bool isDeleted;

  DeleteGymState({this.isLoading = false, this.error, this.isDeleted = false});

  DeleteGymState copyWith({bool? isLoading, String? error, bool? isDeleted}) {
    return DeleteGymState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

class DeleteGymNotifier extends StateNotifier<DeleteGymState> {
  DeleteGymNotifier(this.ref) : super(DeleteGymState());

  final Ref ref;

  Future<void> deleteGym(String gymId) async {
    state = state.copyWith(isLoading: true, error: null, isDeleted: false);

    try {
      final repository = ref.read(gymRepositoryProvider);
      await repository.deleteGym(gymId);
      state = state.copyWith(isLoading: false, isDeleted: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void reset() {
    state = DeleteGymState();
  }
}

final deleteGymProvider =
    StateNotifierProvider<DeleteGymNotifier, DeleteGymState>((ref) {
      return DeleteGymNotifier(ref);
    });
