import 'package:equatable/equatable.dart';
import 'package:feature_voting/features/voting/domain/entities/feature.dart';

abstract class FeatureState extends Equatable {
  const FeatureState();

  @override
  List<Object> get props => [];
}

class FeatureInitial extends FeatureState {}

class FeatureLoading extends FeatureState {}

class FeatureLoaded extends FeatureState {
  final List<Feature> features;
  final String? successMessage;

  const FeatureLoaded({required this.features, this.successMessage});

  FeatureLoaded copyWith({List<Feature>? features, String? successMessage}) {
    return FeatureLoaded(
      features: features ?? this.features,
      successMessage: successMessage,
    );
  }

  @override
  List<Object> get props => [features, successMessage ?? ''];
}

class FeatureError extends FeatureState {
  final String message;

  const FeatureError({required this.message});

  @override
  List<Object> get props => [message];
}
