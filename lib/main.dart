import 'package:feature_voting/app.dart';
import 'package:feature_voting/locator.dart';
import 'package:feature_voting/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  await getIt.allReady();
  runApp(AppProvidersBloc(child: const FeatureVotingApp()));
}
