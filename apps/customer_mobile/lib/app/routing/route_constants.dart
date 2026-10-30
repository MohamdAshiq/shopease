// App Route paths
abstract final class RoutePaths {
  static const home = '/';
  static const store = '/store';
  static const wishlist = '/wishlist';
  static const profile = '/profile';
  static const search = '/search';
  static const productDetail = '/product/:id';

  // Helper method for path-based navigation
  static String productDetailOf(String id) => '/product/$id';
  static String storeWithCategory(String category) =>
      Uri(path: store, queryParameters: {'category': category}).toString();
}

// App Route Names
abstract final class RouteNames {
  static const home = 'home';
  static const store = 'store';
  static const wishlist = 'wishlist';
  static const profile = 'profile';
  static const search = 'search';
  static const productDetail = 'productDetail';
}
