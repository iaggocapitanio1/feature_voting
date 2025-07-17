import 'dart:convert';

import '../../domain/entities/feature.dart';

class FeatureModel extends Feature {
  const FeatureModel({
    required super.id,
    required super.title,
    required super.description,
    required super.author,
    required super.createdAt,
    super.status,
    super.tags,
    super.votes,
    super.voters,
  });

  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      author: json['author'],
      createdAt: DateTime.parse(json['createdAt']),
      status: FeatureStatus.values[json['status'] ?? 0],
      tags: List<String>.from(json['tags'] ?? []),
      votes: json['votes'] ?? 0,
      voters: List<String>.from(json['voters'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'author': author,
      'createdAt': createdAt.toIso8601String(),
      'status': status.index,
      'tags': tags,
      'votes': votes,
      'voters': voters,
    };
  }

  factory FeatureModel.fromEntity(Feature feature) {
    return FeatureModel(
      id: feature.id,
      title: feature.title,
      description: feature.description,
      author: feature.author,
      createdAt: feature.createdAt,
      status: feature.status,
      tags: feature.tags,
      votes: feature.votes,
      voters: feature.voters,
    );
  }

  // Database serialization methods
  factory FeatureModel.fromDatabaseMap(Map<String, dynamic> map) {
    return FeatureModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      author: map['author'],
      createdAt: DateTime.parse(map['createdAt']),
      status: FeatureStatus.values[map['status']],
      tags: List<String>.from(jsonDecode(map['tags'])),
      votes: map['votes'],
      voters: List<String>.from(jsonDecode(map['voters'])),
    );
  }

  Map<String, dynamic> toDatabaseMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'author': author,
      'createdAt': createdAt.toIso8601String(),
      'status': status.index,
      'tags': jsonEncode(tags),
      'votes': votes,
      'voters': jsonEncode(voters),
    };
  }
}
