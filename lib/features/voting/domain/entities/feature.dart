import 'package:equatable/equatable.dart';

enum FeatureStatus { pending, inProgress, completed, rejected }

class Feature extends Equatable {
  final String id;
  final String title;
  final String description;
  final String author;
  final DateTime createdAt;
  final FeatureStatus status;
  final List<String> tags;
  final int votes;
  final List<String> voters;

  const Feature({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.createdAt,
    this.status = FeatureStatus.pending,
    this.tags = const [],
    this.votes = 0,
    this.voters = const [],
  });

  Feature copyWith({
    String? id,
    String? title,
    String? description,
    String? author,
    DateTime? createdAt,
    FeatureStatus? status,
    List<String>? tags,
    int? votes,
    List<String>? voters,
  }) {
    return Feature(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      votes: votes ?? this.votes,
      voters: voters ?? this.voters,
    );
  }

  bool hasUserVoted(String userId) {
    return voters.contains(userId);
  }

  Feature toggleVote(String userId) {
    final newVoters = List<String>.from(voters);
    int newVotes = votes;

    if (hasUserVoted(userId)) {
      newVoters.remove(userId);
      newVotes--;
    } else {
      newVoters.add(userId);
      newVotes++;
    }

    return copyWith(votes: newVotes, voters: newVoters);
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    author,
    createdAt,
    status,
    tags,
    votes,
    voters,
  ];
}
