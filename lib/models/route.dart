import 'package:uuid/uuid.dart';

/// Represents a climbing route with its metadata and photo.
class Route {
  final String id;
  final String name;
  final String? grade;
  final String photoPath;
  final DateTime createdAt;
  final String? createdBy;

  Route({
    String? id,
    required this.name,
    this.grade,
    required this.photoPath,
    DateTime? createdAt,
    this.createdBy,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  /// Creates a Route from a JSON map.
  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      id: json['id'] as String,
      name: json['name'] as String,
      grade: json['grade'] as String?,
      photoPath: json['photoPath'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdBy: json['createdBy'] as String?,
    );
  }

  /// Converts the Route to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'grade': grade,
      'photoPath': photoPath,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
    };
  }

  /// Creates a copy of this Route with updated fields.
  Route copyWith({
    String? id,
    String? name,
    String? grade,
    String? photoPath,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return Route(
      id: id ?? this.id,
      name: name ?? this.name,
      grade: grade ?? this.grade,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Route && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Route(id: $id, name: $name, grade: $grade, createdAt: $createdAt)';
  }
}

