import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../features/cart/views/cart_screen.dart';
import '../../features/checkout/views/checkout_screen.dart';
import '../../features/checkout/views/order_success_screen.dart';
import '../../features/home/views/customer_shell.dart';
import '../../features/home/views/home_screen.dart';
import '../../features/orders/views/my_orders_screen.dart';
import '../../features/orders/views/order_detail_screen.dart';
import '../../features/product/views/product_detail_screen.dart';
import '../../features/profile/views/profile_screen.dart';
import '../../features/profile/views/shipping_addresses_screen.dart';
import '../../features/search/views/search_screen.dart';
import '../../features/store/views/store_screen.dart';
import '../../features/wishlist/views/wishlist_screen.dart';
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
              builder: (context, state) => const WishlistScreen(),
            ),
          ],
        ),

        // Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.profile,
              name: RouteNames.profile,
              builder: (context, state) => const ProfileScreen(),
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

    // Cart Screen
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.cart,
      name: RouteNames.cart,
      builder: (context, state) => const CartScreen(),
    ),

    // Checkout Screen
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.checkout,
      name: RouteNames.checkout,
      builder: (context, state) => const CheckoutScreen(),
    ),

    // Order Success Screen
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.orderSuccess,
      name: RouteNames.orderSuccess,
      builder: (context, state) {
        final order = state.extra as OrderModel? ?? mockOrders.first;
        return OrderSuccessScreen(order: order);
      },
    ),

    // Order Tracking & Detail Route
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.orderDetail,
      name: RouteNames.orderDetail,
      builder: (context, state) {
        final orderId = state.pathParameters['id'] ?? '';
        final initialOrder = state.extra as OrderModel?;
        return OrderDetailScreen(orderId: orderId, initialOrder: initialOrder);
      },
    ),

    // My Orders Screen
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.orders,
      name: RouteNames.orders,
      builder: (context, state) => const MyOrdersScreen(),
    ),

    // Saved Addresses Screen
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.addresses,
      name: RouteNames.addresses,
      builder: (context, state) => const ShippingAddressesScreen(),
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
        final initialSize = state.uri.queryParameters['size'];
        return ProductDetailScreen(product: product, initialSize: initialSize);
      },
    ),
  ],
);
