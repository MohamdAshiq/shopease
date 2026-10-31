// App Route paths
abstract final class RoutePaths {
  static const home = '/';
  static const store = '/store';
  static const wishlist = '/wishlist';
  static const profile = '/profile';
  static const orders = '/orders';
  static const addresses = '/addresses';
  static const search = '/search';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const orderSuccess = '/order-success';
  static const orderDetail = '/orders/:id';
  static const productDetail = '/product/:id';

  // Helper method for path-based navigation
  static String productDetailOf(String id) => '/product/$id';
  static String orderDetailOf(String id) => '/orders/$id';
  static String storeWithCategory(String category) =>
      Uri(path: store, queryParameters: {'category': category}).toString();
}

// App Route Names
abstract final class RouteNames {
  static const home = 'home';
  static const store = 'store';
  static const wishlist = 'wishlist';
  static const profile = 'profile';
  static const orders = 'orders';
  static const addresses = 'addresses';
  static const search = 'search';
  static const cart = 'cart';
  static const checkout = 'checkout';
  static const orderSuccess = 'orderSuccess';
  static const orderDetail = 'orderDetail';
  static const productDetail = 'productDetail';
}
