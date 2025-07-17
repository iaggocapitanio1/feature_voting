import 'package:feature_voting/features/voting/data/models/feature_model.dart';

import '../../domain/entities/feature.dart';

abstract class FeatureLocalDataSource {
  Future<List<FeatureModel>> getFeatures();
  Future<void> addFeature(FeatureModel feature);
  Future<FeatureModel> updateFeature(FeatureModel feature);
  Future<FeatureModel?> getFeatureById(String id);
}

class FeatureLocalDataSourceImpl implements FeatureLocalDataSource {
  final List<FeatureModel> _features = [
    FeatureModel(
      id: '1',
      title: 'Dark Mode Support',
      description:
          'Add dark mode theme to improve user experience in low-light environments.',
      author: 'John Doe',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      votes: 42,
      voters: const ['user1', 'user2', 'user3'],
      tags: const ['UI', 'Theme', 'Accessibility'],
      status: FeatureStatus.inProgress,
    ),
    FeatureModel(
      id: '2',
      title: 'Push Notifications',
      description:
          'Implement push notifications for important updates and reminders.',
      author: 'Jane Smith',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      votes: 28,
      voters: const ['user4', 'user5'],
      tags: const ['Notifications', 'Mobile'],
      status: FeatureStatus.pending,
    ),
    FeatureModel(
      id: '3',
      title: 'Offline Mode',
      description: 'Allow users to access basic features when offline.',
      author: 'Mike Johnson',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      votes: 15,
      voters: const ['user6'],
      tags: const ['Offline', 'Performance'],
      status: FeatureStatus.pending,
    ),
    FeatureModel(
      id: '4',
      title: 'Export Data',
      description:
          'Add ability to export user data in various formats (CSV, JSON, PDF).',
      author: 'Sarah Wilson',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      votes: 8,
      voters: const [],
      tags: const ['Export', 'Data'],
      status: FeatureStatus.pending,
    ),
  ];

  @override
  Future<List<FeatureModel>> getFeatures() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_features);
  }

  @override
  Future<void> addFeature(FeatureModel feature) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _features.add(feature);
  }

  @override
  Future<FeatureModel> updateFeature(FeatureModel feature) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _features.indexWhere((f) => f.id == feature.id);
    if (index != -1) {
      _features[index] = feature;
      return feature;
    }
    throw Exception('Feature not found');
  }

  @override
  Future<FeatureModel?> getFeatureById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _features.firstWhere((feature) => feature.id == id);
    } catch (e) {
      return null;
    }
  }
}
