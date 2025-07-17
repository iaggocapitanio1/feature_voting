import 'package:feature_voting/core/db/database_helper.dart';

import '../models/feature_model.dart';

abstract class FeatureLocalDataSource {
  Future<List<FeatureModel>> getFeatures();
  Future<void> addFeature(FeatureModel feature);
  Future<FeatureModel> updateFeature(FeatureModel feature);
  Future<FeatureModel?> getFeatureById(String id);
}

class FeatureLocalDataSourceImpl implements FeatureLocalDataSource {
  final DatabaseHelper _databaseHelper;

  FeatureLocalDataSourceImpl({required DatabaseHelper databaseHelper})
    : _databaseHelper = databaseHelper;

  @override
  Future<List<FeatureModel>> getFeatures() async {
    try {
      final featuresData = await _databaseHelper.getAllFeatures();
      return featuresData
          .map((data) => FeatureModel.fromDatabaseMap(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to load features: $e');
    }
  }

  @override
  Future<void> addFeature(FeatureModel feature) async {
    try {
      await _databaseHelper.insertFeature(feature.toDatabaseMap());
    } catch (e) {
      throw Exception('Failed to add feature: $e');
    }
  }

  @override
  Future<FeatureModel> updateFeature(FeatureModel feature) async {
    try {
      final result = await _databaseHelper.updateFeature(
        feature.toDatabaseMap(),
      );
      if (result > 0) {
        return feature;
      } else {
        throw Exception('Feature not found');
      }
    } catch (e) {
      throw Exception('Failed to update feature: $e');
    }
  }

  @override
  Future<FeatureModel?> getFeatureById(String id) async {
    try {
      final featureData = await _databaseHelper.getFeatureById(id);
      if (featureData != null) {
        return FeatureModel.fromDatabaseMap(featureData);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get feature by id: $e');
    }
  }
}
