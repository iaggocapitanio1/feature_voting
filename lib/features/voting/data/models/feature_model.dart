import 'package:feature_voting/features/voting/domain/entities/feature.dart';

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
}
