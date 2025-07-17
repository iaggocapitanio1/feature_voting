import 'package:feature_voting/core/arch/usecases.dart';
import 'package:feature_voting/features/voting/domain/entities/feature.dart';
import 'package:feature_voting/features/voting/domain/repositories/feature_repository.dart';

class GetFeatures implements UseCase<List<Feature>, GetFeaturesParams> {
  final FeatureRepository repository;

  GetFeatures(this.repository);

  @override
  Future<List<Feature>> call(GetFeaturesParams params) async {
    List<Feature> features;

    if (params.status != null) {
      features = await repository.getFeaturesByStatus(params.status!);
    } else {
      features = await repository.getFeatures();
    }

    // Apply sorting
    switch (params.sortBy) {
      case SortBy.votes:
        features.sort((a, b) => b.votes.compareTo(a.votes));
        break;
      case SortBy.date:
        features.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    return features;
  }
}

class GetFeaturesParams {
  final FeatureStatus? status;
  final SortBy sortBy;

  GetFeaturesParams({this.status, this.sortBy = SortBy.votes});
}

enum SortBy { votes, date }
