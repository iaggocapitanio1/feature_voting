import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteNames {
  static const String home = '/';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteNames.home,
  routes: <RouteBase>[],
);
