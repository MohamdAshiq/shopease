import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../features/auth/views/forgot_password_screen.dart';
import '../../features/auth/views/login_screen.dart';
import '../../features/auth/views/register_screen.dart';
import '../../features/cart/views/cart_screen.dart';
import '../../features/checkout/views/checkout_screen.dart';
import '../../features/checkout/views/order_success_screen.dart';
import '../../features/home/views/customer_shell.dart';
import '../../features/home/views/home_screen.dart';
import '../../features/home/views/popular_products_screen.dart';
import '../../features/orders/views/my_orders_screen.dart';
import '../../features/orders/views/order_detail_screen.dart';
import '../../features/product/views/product_detail_screen.dart';
import '../../features/profile/views/profile_screen.dart';
import '../../features/profile/views/shipping_addresses_screen.dart';
import '../../features/search/views/search_screen.dart';
import '../../features/splash/views/splash_screen.dart';
import '../../features/store/views/store_screen.dart';
import '../../features/wishlist/views/wishlist_screen.dart';
import 'route_constants.dart';

export 'route_constants.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

// Application routing configuration
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RoutePaths.splash,
  routes: [
    // Splash Screen
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.splash,
      name: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),

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

    // Popular Products Screen
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.popularProducts,
      name: RouteNames.popularProducts,
      builder: (context, state) => const PopularProductsScreen(),
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
      redirect: (context, state) =>
          state.extra is! OrderModel ? RoutePaths.home : null,
      builder: (context, state) =>
          OrderSuccessScreen(order: state.extra! as OrderModel),
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
        final product = state.extra as ProductModel?;
        final initialSize = state.uri.queryParameters['size'];
        return ProductDetailScreen(
          productId: id,
          product: product,
          initialSize: initialSize,
        );
      },
    ),

    // Login Route
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.login,
      name: RouteNames.login,
      builder: (context, state) {
        final redirect = state.uri.queryParameters['redirect'];
        return LoginScreen(redirect: redirect);
      },
    ),

    // Register Route
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.register,
      name: RouteNames.register,
      builder: (context, state) {
        final redirect = state.uri.queryParameters['redirect'];
        return RegisterScreen(redirect: redirect);
      },
    ),

    // Forgot Password Route
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.forgotPassword,
      name: RouteNames.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
  ],
);
