import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/voting/data/models/feature_model.dart';
import '../../features/voting/domain/entities/feature.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'feature_voting.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE features(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        author TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        status INTEGER NOT NULL,
        tags TEXT NOT NULL,
        votes INTEGER NOT NULL,
        voters TEXT NOT NULL
      )
    ''');

    // Insert initial data
    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
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

  Future<List<Map<String, dynamic>>> getAllFeatures() async {
    final db = await database;
    return await db.query('features', orderBy: 'createdAt DESC');
  }

  Future<Map<String, dynamic>?> getFeatureById(String id) async {
    final db = await database;
    final results = await db.query(
      'features',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> insertFeature(Map<String, dynamic> feature) async {
    final db = await database;
    return await db.insert('features', feature);
  }

  Future<int> updateFeature(Map<String, dynamic> feature) async {
    final db = await database;
    return await db.update(
      'features',
      feature,
      where: 'id = ?',
      whereArgs: [feature['id']],
    );
  }

  Future<int> deleteFeature(String id) async {
    final db = await database;
    return await db.delete('features', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
