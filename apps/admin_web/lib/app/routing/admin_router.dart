import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../features/auth/views/admin_login_screen.dart';
import '../../features/dashboard/views/admin_dashboard_overview_screen.dart';
import '../../features/dashboard/views/admin_dashboard_screen.dart';
import '../../features/dashboard/views/admin_placeholder_screen.dart';
import 'admin_route_constants.dart';

export 'admin_route_constants.dart';

final GlobalKey<NavigatorState> adminNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

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
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AdminDashboardScreen(child: child);
      },
      routes: [
        GoRoute(
          path: AdminRoutePaths.dashboard,
          name: AdminRouteNames.dashboard,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: AdminDashboardOverviewScreen()),
        ),
        GoRoute(
          path: AdminRoutePaths.products,
          name: AdminRouteNames.products,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AdminPlaceholderScreen(title: 'Products Screen'),
          ),
        ),
        GoRoute(
          path: AdminRoutePaths.orders,
          name: AdminRouteNames.orders,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AdminPlaceholderScreen(title: 'Orders Screen'),
          ),
        ),
        GoRoute(
          path: AdminRoutePaths.customers,
          name: AdminRouteNames.customers,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AdminPlaceholderScreen(title: 'Customers Screen'),
          ),
        ),
        GoRoute(
          path: AdminRoutePaths.settings,
          name: AdminRouteNames.settings,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AdminPlaceholderScreen(title: 'Settings Screen'),
          ),
        ),
      ],
    ),
  ],
);
