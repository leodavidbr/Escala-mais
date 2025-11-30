import 'package:uuid/uuid.dart';

class Gym {
  final String id;
  final String name;
  final String? location;
  final DateTime createdAt;

  Gym({String? id, required this.name, this.location, DateTime? createdAt})
    : id = id ?? const Uuid().v4(),
      createdAt = createdAt ?? DateTime.now();

  factory Gym.fromJson(Map<String, dynamic> json) {
    return Gym(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Gym && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Gym(id: $id, name: $name, location: $location)';
  }
}
