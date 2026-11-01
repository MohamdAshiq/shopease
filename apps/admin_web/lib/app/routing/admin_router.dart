import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../features/auth/views/admin_login_screen.dart';
import '../../features/dashboard/views/admin_dashboard_screen.dart';
import 'admin_route_constants.dart';

export 'admin_route_constants.dart';

final GlobalKey<NavigatorState> adminNavigatorKey = GlobalKey<NavigatorState>();

// Admin Web Router Configuration
final GoRouter adminRouter = GoRouter(
  navigatorKey: adminNavigatorKey,
  initialLocation: AdminRoutePaths.login,
  routes: [
    GoRoute(
      path: AdminRoutePaths.login,
      name: AdminRouteNames.login,
      builder: (context, state) => const AdminLoginScreen(),
    ),
    GoRoute(
      path: AdminRoutePaths.dashboard,
      name: AdminRouteNames.dashboard,
      builder: (context, state) => const AdminDashboardScreen(),
    ),
  ],
);
