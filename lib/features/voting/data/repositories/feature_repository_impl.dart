import '../../domain/entities/feature.dart';
import '../../domain/repositories/feature_repository.dart';
import '../datasources/feature_local_data_source.dart';
import '../models/feature_model.dart';

class FeatureRepositoryImpl implements FeatureRepository {
  final FeatureLocalDataSource localDataSource;

  FeatureRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Feature>> getFeatures() async {
    final featureModels = await localDataSource.getFeatures();
    return featureModels.cast<Feature>();
  }

  @override
  Future<List<Feature>> getFeaturesByStatus(FeatureStatus status) async {
    final features = await getFeatures();
    return features.where((feature) => feature.status == status).toList();
  }

  @override
  Future<void> addFeature(Feature feature) async {
    final featureModel = FeatureModel.fromEntity(feature);
    await localDataSource.addFeature(featureModel);
  }

  @override
  Future<Feature> voteFeature(String featureId, String userId) async {
    final featureModel = await localDataSource.getFeatureById(featureId);
    if (featureModel == null) {
      throw Exception('Feature not found');
    }

    final updatedFeature = featureModel.toggleVote(userId);
    final updatedModel = FeatureModel.fromEntity(updatedFeature);

    return await localDataSource.updateFeature(updatedModel);
  }

  @override
  Future<void> updateFeatureStatus(
    String featureId,
    FeatureStatus status,
  ) async {
    final featureModel = await localDataSource.getFeatureById(featureId);
    if (featureModel == null) {
      throw Exception('Feature not found');
    }

    final updatedFeature = featureModel.copyWith(status: status);
    final updatedModel = FeatureModel.fromEntity(updatedFeature);

    await localDataSource.updateFeature(updatedModel);
  }
}
