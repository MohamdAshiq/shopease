import 'package:customer_mobile/features/wishlist/cubits/wishlist_cubit.dart';
import 'package:customer_mobile/features/wishlist/cubits/wishlist_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopease_core/shopease_core.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testProduct1 = ProductModel(
    id: 'prod_wishlist_1',
    title: 'Wireless Noise Cancelling Headphones',
    description: 'High-fidelity audio experience',
    price: 3999.0,
    stock: 15,
    category: 'Electronics',
    imageUrl: 'https://example.com/headphones.jpg',
  );

  const testProduct2 = ProductModel(
    id: 'prod_wishlist_2',
    title: 'Vintage Denim Jacket',
    description: 'Classic denim jacket with modern fit',
    price: 2499.0,
    stock: 0, // out of stock
    category: 'Fashion',
    sizes: ['M', 'L', 'XL'],
    imageUrl: 'https://example.com/jacket.jpg',
  );

  group('WishlistCubit Unit Tests', () {
    late WishlistCubit cubit;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      cubit = WishlistCubit(initialItems: []);
    });

    tearDown(() {
      cubit.close();
    });

    test('starts with empty list when initialItems is empty', () {
      expect(cubit.state.isEmpty, isTrue);
      expect(cubit.state.itemCount, 0);
      expect(cubit.state.items, isEmpty);
      expect(cubit.state.selectedFilter, WishlistFilter.all);
    });

    test('addToWishlist inserts item and updates state', () {
      cubit.addToWishlist(testProduct1);

      expect(cubit.state.isNotEmpty, isTrue);
      expect(cubit.state.itemCount, 1);
      expect(cubit.state.isFavorite(testProduct1.id), isTrue);
      expect(cubit.state.items.first, testProduct1);
    });

    test('addToWishlist does not add duplicates', () {
      cubit.addToWishlist(testProduct1);
      cubit.addToWishlist(testProduct1);

      expect(cubit.state.itemCount, 1);
    });

    test('removeFromWishlist removes product and updates state', () {
      cubit.addToWishlist(testProduct1);
      cubit.addToWishlist(testProduct2);
      expect(cubit.state.itemCount, 2);

      cubit.removeFromWishlist(testProduct1.id);

      expect(cubit.state.itemCount, 1);
      expect(cubit.state.isFavorite(testProduct1.id), isFalse);
      expect(cubit.state.isFavorite(testProduct2.id), isTrue);
    });

    test('toggleWishlist adds if absent and removes if present', () {
      final added = cubit.toggleWishlist(testProduct1);
      expect(added, isTrue);
      expect(cubit.state.isFavorite(testProduct1.id), isTrue);

      final removed = cubit.toggleWishlist(testProduct1);
      expect(removed, isFalse);
      expect(cubit.state.isFavorite(testProduct1.id), isFalse);
    });

    test('clearWishlist empties all items', () {
      cubit.addToWishlist(testProduct1);
      cubit.addToWishlist(testProduct2);
      expect(cubit.state.itemCount, 2);

      cubit.clearWishlist();

      expect(cubit.state.isEmpty, isTrue);
      expect(cubit.state.itemCount, 0);
    });

    test('setFilter updates selectedFilter and filteredItems', () {
      cubit.addToWishlist(testProduct1); // inStock = true
      cubit.addToWishlist(testProduct2); // inStock = false

      expect(cubit.state.selectedFilter, WishlistFilter.all);
      expect(cubit.state.filteredItems.length, 2);

      cubit.setFilter(WishlistFilter.inStock);
      expect(cubit.state.selectedFilter, WishlistFilter.inStock);
      expect(cubit.state.filteredItems.length, 1);
      expect(cubit.state.filteredItems.first, testProduct1);

      cubit.setFilter(WishlistFilter.all);
      expect(cubit.state.filteredItems.length, 2);
    });
  });
}
