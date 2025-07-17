import 'package:feature_voting/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/voting/presentation/cubits/feature_cubit.dart';

class AppProvidersBloc extends StatelessWidget {
  final Widget child;
  const AppProvidersBloc({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => getIt<FeatureCubit>())],
      child: child,
    );
  }
}
