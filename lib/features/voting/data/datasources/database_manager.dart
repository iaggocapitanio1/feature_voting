import 'package:feature_voting/core/db/database_helper.dart';
import 'package:feature_voting/features/voting/data/models/feature_model.dart';
import 'package:feature_voting/features/voting/domain/entities/feature.dart';

class DatabaseManager {
  final DatabaseHelper _databaseHelper;

  DatabaseManager(this._databaseHelper);

  /// Clear all data and reset with initial data
  Future<void> resetDatabase() async {
    final db = await _databaseHelper.database;

    // Clear existing data
    await db.delete('features');

    // Insert initial data
    final initialFeatures = [
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

    for (final feature in initialFeatures) {
      await db.insert('features', feature.toDatabaseMap());
    }
  }

  /// Get database statistics
  Future<Map<String, int>> getDatabaseStats() async {
    final db = await _databaseHelper.database;

    final totalFeatures = await db.rawQuery(
      'SELECT COUNT(*) as count FROM features',
    );
    final pendingFeatures = await db.rawQuery(
      'SELECT COUNT(*) as count FROM features WHERE status = 0',
    );
    final inProgressFeatures = await db.rawQuery(
      'SELECT COUNT(*) as count FROM features WHERE status = 1',
    );
    final completedFeatures = await db.rawQuery(
      'SELECT COUNT(*) as count FROM features WHERE status = 2',
    );

    return {
      'total': totalFeatures.first['count'] as int,
      'pending': pendingFeatures.first['count'] as int,
      'inProgress': inProgressFeatures.first['count'] as int,
      'completed': completedFeatures.first['count'] as int,
    };
  }

  /// Export all features as JSON
  Future<List<Map<String, dynamic>>> exportFeatures() async {
    final features = await _databaseHelper.getAllFeatures();
    return features;
  }
}
