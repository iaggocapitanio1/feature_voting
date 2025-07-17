import 'package:feature_voting/features/voting/presentation/pages/add_feature_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/voting/presentation/pages/home_page.dart';

class RouteNames {
  static const String home = '/';
  static const String addFeature = '/add-feature';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteNames.home,
  routes: <RouteBase>[
    GoRoute(
      path: RouteNames.home,
      name: 'home',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Start the animation off-screen (left)
          const begin = Offset(-1.0, 0.0);
          // End the animation at the screen's origin
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    ),
    GoRoute(
      path: RouteNames.addFeature,
      name: 'addFeature',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const AddFeaturePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Start the animation off-screen (right)
          const begin = Offset(1.0, 0.0);
          // End the animation at the screen's origin
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    ),
  ],
);
