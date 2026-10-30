import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../features/home/views/customer_shell.dart';
import '../../features/home/views/home_screen.dart';
import '../../features/product/views/product_detail_screen.dart';
import '../../features/search/views/search_screen.dart';
import '../../features/store/views/store_screen.dart';
import '../../widgets/placeholder_screen.dart';
import 'route_constants.dart';

export 'route_constants.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

// Application routing configuration
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RoutePaths.home,
  routes: [
    // Bottom navigation shell
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return CustomerShell(navigationShell: navigationShell);
      },
      branches: [
        // Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.home,
              name: RouteNames.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // Store
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.store,
              name: RouteNames.store,
              builder: (context, state) {
                final category =
                    state.uri.queryParameters['category'] ??
                    state.extra as String? ??
                    'All';
                return StoreScreen(
                  key: ValueKey('store_screen_$category'),
                  initialCategory: category,
                );
              },
            ),
          ],
        ),

        // Wishlist
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.wishlist,
              name: RouteNames.wishlist,
              builder: (context, state) => const PlaceholderScreen(
                title: 'Wishlist',
                icon: IconsaxPlusLinear.heart,
              ),
            ),
          ],
        ),

        // Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.profile,
              name: RouteNames.profile,
              builder: (context, state) => const PlaceholderScreen(
                title: 'Profile',
                icon: IconsaxPlusLinear.user,
              ),
            ),
          ],
        ),
      ],
    ),

    // Search Screen
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.search,
      name: RouteNames.search,
      builder: (context, state) => const SearchScreen(),
    ),

    // Product Detail Route
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.productDetail,
      name: RouteNames.productDetail,
      builder: (context, state) {
        final id = state.pathParameters['id'];
        final product =
            state.extra as ProductModel? ??
            mockProducts.firstWhere(
              (p) => p.id == id,
              orElse: () => mockProducts.first,
            );
        return ProductDetailScreen(product: product);
      },
    ),
  ],
);
