import 'package:feature_voting/core/arch/usecases.dart';
import 'package:feature_voting/features/voting/domain/entities/feature.dart';
import 'package:feature_voting/features/voting/domain/repositories/feature_repository.dart';

class AddFeature implements UseCase<void, AddFeatureParams> {
  final FeatureRepository repository;

  AddFeature(this.repository);

  @override
  Future<void> call(AddFeatureParams params) async {
    final feature = Feature(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: params.title,
      description: params.description,
      author: params.author,
      createdAt: DateTime.now(),
      tags: params.tags,
    );

    await repository.addFeature(feature);
  }
}

class AddFeatureParams {
  final String title;
  final String description;
  final String author;
  final List<String> tags;

  AddFeatureParams({
    required this.title,
    required this.description,
    required this.author,
    required this.tags,
  });
}
