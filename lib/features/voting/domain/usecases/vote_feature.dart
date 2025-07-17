import 'package:feature_voting/core/arch/usecases.dart';
import 'package:feature_voting/features/voting/domain/entities/feature.dart';
import 'package:feature_voting/features/voting/domain/repositories/feature_repository.dart';

class VoteFeature implements UseCase<Feature, VoteFeatureParams> {
  final FeatureRepository repository;

  VoteFeature(this.repository);

  @override
  Future<Feature> call(VoteFeatureParams params) async {
    return await repository.voteFeature(params.featureId, params.userId);
  }
}

class VoteFeatureParams {
  final String featureId;
  final String userId;

  VoteFeatureParams({required this.featureId, required this.userId});
}
