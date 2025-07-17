import 'package:feature_voting/features/voting/data/datasources/feature_local_data_source.dart';
import 'package:feature_voting/features/voting/data/repositories/feature_repository_impl.dart';
import 'package:feature_voting/features/voting/domain/repositories/feature_repository.dart';
import 'package:feature_voting/features/voting/domain/usecases/add_feature.dart';
import 'package:feature_voting/features/voting/domain/usecases/get_features.dart';
import 'package:feature_voting/features/voting/domain/usecases/vote_feature.dart';
import 'package:feature_voting/features/voting/presentation/cubits/feature_cubit.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> init() async {
  //Cubits
  getIt.registerFactory(
    () => FeatureCubit(
      getFeatures: getIt(),
      addFeature: getIt(),
      voteFeature: getIt(),
    ),
  );
  // Use cases
  getIt.registerLazySingleton(() => GetFeatures(getIt()));
  getIt.registerLazySingleton(() => AddFeature(getIt()));
  getIt.registerLazySingleton(() => VoteFeature(getIt()));

  // Repository
  getIt.registerLazySingleton<FeatureRepository>(
    () => FeatureRepositoryImpl(localDataSource: getIt()),
  );

  // Data sources
  getIt.registerLazySingleton<FeatureLocalDataSource>(
    () => FeatureLocalDataSourceImpl(),
  );
}
