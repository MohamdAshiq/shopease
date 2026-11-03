import 'package:customer_mobile/features/search/cubits/search_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopease_core/shopease_core.dart';

final List<ProductModel> _testProducts = [
  const ProductModel(
    id: 'test_1',
    title: 'Sony Wireless Headphones',
    description: 'Noise canceling headphones',
    price: 299.99,
    stock: 10,
    category: 'Electronics',
  ),
  const ProductModel(
    id: 'test_2',
    title: 'Nike Running Shoes',
    description: 'Cushioned running sneakers',
    price: 129.99,
    stock: 5,
    category: 'Footwear',
  ),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SearchCubit', () {
    late SearchCubit cubit;

    setUp(() {
      SharedPreferences.setMockInitialValues({
        'shopease_recent_searches': <String>[],
      });
      cubit = SearchCubit(initialProducts: _testProducts);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has empty query and empty recent searches', () {
      expect(cubit.state.searchQuery, isEmpty);
      expect(cubit.state.isIdle, isTrue);
      expect(cubit.state.recentSearches, isEmpty);
    });

    test('updateQuery filters mock products matching query', () {
      cubit.updateQuery('Headphones');
      expect(cubit.state.isIdle, isFalse);
      expect(cubit.state.hasResults, isTrue);
      expect(
        cubit.state.searchResults.any((p) => p.title.contains('Headphones')),
        isTrue,
      );
      expect(cubit.state.recentSearches, isEmpty);
    });

    test('updateQuery with no match returns empty results', () {
      cubit.updateQuery('xyznonexistentproductquery123');
      expect(cubit.state.isIdle, isFalse);
      expect(cubit.state.hasResults, isFalse);
    });

    test('submitSearch persists term to recentSearches at front', () async {
      await cubit.submitSearch('Smart Watch');
      expect(cubit.state.recentSearches.first, 'Smart Watch');

      await cubit.submitSearch('a');
      expect(cubit.state.recentSearches.length, 1);
    });

    test('removeRecentSearch removes term from recentSearches', () async {
      await cubit.submitSearch('Earbuds');
      await cubit.submitSearch('Mouse');
      expect(cubit.state.recentSearches.contains('Earbuds'), isTrue);

      await cubit.removeRecentSearch('Earbuds');
      expect(cubit.state.recentSearches.contains('Earbuds'), isFalse);
    });

    test('clearRecentSearches empties recent searches', () async {
      await cubit.submitSearch('Keyboard');
      expect(cubit.state.recentSearches, isNotEmpty);

      await cubit.clearRecentSearches();
      expect(cubit.state.recentSearches, isEmpty);
    });
  });
}
