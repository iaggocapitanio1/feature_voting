import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppProvidersBloc extends StatelessWidget {
  final Widget child;
  const AppProvidersBloc({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [], child: child);
  }
}
