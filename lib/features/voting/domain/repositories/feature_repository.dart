import 'package:feature_voting/features/voting/domain/entities/feature.dart';

abstract class FeatureRepository {
  Future<List<Feature>> getFeatures();
  Future<List<Feature>> getFeaturesByStatus(FeatureStatus status);
  Future<void> addFeature(Feature feature);
  Future<Feature> voteFeature(String featureId, String userId);
  Future<void> updateFeatureStatus(String featureId, FeatureStatus status);
}
