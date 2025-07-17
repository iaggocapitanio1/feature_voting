import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/feature.dart';
import '../../domain/usecases/add_feature.dart';
import '../../domain/usecases/get_features.dart';
import '../../domain/usecases/vote_feature.dart';
import 'feature_state.dart';

class FeatureCubit extends Cubit<FeatureState> {
  final GetFeatures _getFeatures;
  final AddFeature _addFeature;
  final VoteFeature _voteFeature;

  // Current filter and sort settings
  FeatureStatus? _currentStatus;
  SortBy _currentSortBy = SortBy.votes;

  FeatureCubit({
    required GetFeatures getFeatures,
    required AddFeature addFeature,
    required VoteFeature voteFeature,
  }) : _getFeatures = getFeatures,
       _addFeature = addFeature,
       _voteFeature = voteFeature,
       super(FeatureInitial());

  Future<void> loadFeatures({
    FeatureStatus? status,
    SortBy sortBy = SortBy.votes,
  }) async {
    emit(FeatureLoading());

    try {
      _currentStatus = status;
      _currentSortBy = sortBy;

      final features = await _getFeatures(
        GetFeaturesParams(status: status, sortBy: sortBy),
      );

      emit(FeatureLoaded(features: features));
    } catch (e) {
      emit(FeatureError(message: e.toString()));
    }
  }

  Future<void> refreshFeatures() async {
    await loadFeatures(status: _currentStatus, sortBy: _currentSortBy);
  }

  Future<void> addFeature({
    required String title,
    required String description,
    required String author,
    required List<String> tags,
  }) async {
    try {
      await _addFeature(
        AddFeatureParams(
          title: title,
          description: description,
          author: author,
          tags: tags,
        ),
      );

      // Reload features and show success message
      final features = await _getFeatures(
        GetFeaturesParams(status: _currentStatus, sortBy: _currentSortBy),
      );

      emit(
        FeatureLoaded(
          features: features,
          successMessage: 'Feature added successfully!',
        ),
      );
    } catch (e) {
      emit(FeatureError(message: e.toString()));
    }
  }

  Future<void> voteFeature({
    required String featureId,
    required String userId,
  }) async {
    // Optimistic update - update UI immediately
    if (state is FeatureLoaded) {
      final currentState = state as FeatureLoaded;
      final updatedFeatures = currentState.features.map((feature) {
        if (feature.id == featureId) {
          return feature.toggleVote(userId);
        }
        return feature;
      }).toList();

      emit(FeatureLoaded(features: updatedFeatures));
    }

    try {
      await _voteFeature(
        VoteFeatureParams(featureId: featureId, userId: userId),
      );

      // Reload to ensure consistency with backend
      await refreshFeatures();
    } catch (e) {
      // Revert optimistic update on error
      await refreshFeatures();
      emit(FeatureError(message: e.toString()));
    }
  }

  void clearSuccessMessage() {
    if (state is FeatureLoaded) {
      final currentState = state as FeatureLoaded;
      emit(currentState.copyWith(successMessage: null));
    }
  }

  // Getters for current filter state
  FeatureStatus? get currentStatus => _currentStatus;
  SortBy get currentSortBy => _currentSortBy;
}
