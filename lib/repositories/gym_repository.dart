import 'dart:async';
import '../models/gym.dart';

/// Abstract interface for gym data storage.
abstract class GymRepository {
  /// Returns a stream of all gyms.
  Stream<List<Gym>> getAllGyms();

  /// Retrieves a gym by its ID.
  Future<Gym?> getGymById(String id);

  /// Creates a new gym.
  Future<void> createGym(Gym gym);

  /// Deletes a gym by its ID.
  Future<void> deleteGym(String id);

  Future<bool> resetDatabase();
}
