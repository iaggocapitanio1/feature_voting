import 'package:feature_voting/route.dart';
import 'package:flutter/material.dart';

class FeatureVotingApp extends StatefulWidget {
  const FeatureVotingApp({super.key});

  @override
  State<FeatureVotingApp> createState() => _FeatureVotingAppState();
}

class _FeatureVotingAppState extends State<FeatureVotingApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Feature Voting',
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
