import 'package:customer_mobile/features/cart/cubits/cart_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopease_core/shopease_core.dart';

void main() {
  group('CartCubit', () {
    late CartCubit cubit;

    const testProduct1 = ProductModel(
      id: 'prod_1',
      title: 'Purple Hoodie',
      description: 'Cozy hoodie',
      price: 1200.0,
      stock: 5,
      category: 'Clothing',
      imageUrl: 'https://example.com/hoodie.jpg',
    );

    const testProduct2 = ProductModel(
      id: 'prod_2',
      title: 'Water Bottle',
      description: 'Steel bottle',
      price: 400.0,
      stock: 10,
      category: 'Accessories',
      imageUrl: 'https://example.com/bottle.jpg',
    );

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      cubit = CartCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial cart state is empty', () {
      expect(cubit.state.isEmpty, isTrue);
      expect(cubit.state.totalItemCount, 0);
      expect(cubit.state.subtotal, 0.0);
      expect(cubit.state.deliveryFee, 0.0);
      expect(cubit.state.total, 0.0);
    });

    test('addToCart adds a new item to cart', () {
      cubit.addToCart(testProduct1, selectedSize: 'M', quantity: 1);

      expect(cubit.state.items.length, 1);
      expect(cubit.state.totalItemCount, 1);
      expect(cubit.state.subtotal, 1200.0);
      expect(cubit.state.deliveryFee, 0.0); // Subtotal >= 999 is free delivery
      expect(cubit.state.total, 1200.0);
    });

    test('addToCart with standard delivery fee when subtotal < 999', () {
      cubit.addToCart(testProduct2, quantity: 1); // 400.0

      expect(cubit.state.subtotal, 400.0);
      expect(cubit.state.deliveryFee, 49.0);
      expect(cubit.state.total, 449.0);
    });

    test('addToCart for existing item with same size increments quantity', () {
      cubit.addToCart(testProduct1, selectedSize: 'M', quantity: 1);
      cubit.addToCart(testProduct1, selectedSize: 'M', quantity: 2);

      expect(cubit.state.items.length, 1);
      expect(cubit.state.items.first.quantity, 3);
      expect(cubit.state.totalItemCount, 3);
    });

    test('addToCart for same product with different size creates new item', () {
      cubit.addToCart(testProduct1, selectedSize: 'M', quantity: 1);
      cubit.addToCart(testProduct1, selectedSize: 'L', quantity: 1);

      expect(cubit.state.items.length, 2);
      expect(cubit.state.totalItemCount, 2);
    });

    test(
      'addToCart respects product stock limit and reports maxStockReached',
      () {
        final res1 = cubit.addToCart(
          testProduct1,
          selectedSize: 'M',
          quantity: 5,
        );
        expect(res1, AddToCartResult.success);
        expect(cubit.state.items.first.quantity, 5);

        final res2 = cubit.addToCart(
          testProduct1,
          selectedSize: 'M',
          quantity: 1,
        );
        expect(res2, AddToCartResult.maxStockReached);
        expect(cubit.state.items.first.quantity, 5);
      },
    );

    test('isProductInCart accurately matches size and product id', () {
      cubit.addToCart(testProduct1, selectedSize: 'M', quantity: 1);

      expect(cubit.state.isProductInCart('prod_1', 'M'), isTrue);
      expect(cubit.state.isProductInCart('prod_1', 'L'), isFalse);
      expect(cubit.state.isProductInCart('prod_2'), isFalse);
    });

    test('updateQuantity updates item quantity', () {
      cubit.addToCart(testProduct1, selectedSize: 'M', quantity: 1);
      cubit.updateQuantity('prod_1', 'M', 4);

      expect(cubit.state.items.first.quantity, 4);
    });

    test('updateQuantity to 0 removes the item', () {
      cubit.addToCart(testProduct1, selectedSize: 'M', quantity: 1);
      cubit.updateQuantity('prod_1', 'M', 0);

      expect(cubit.state.isEmpty, isTrue);
    });

    test('removeFromCart removes specific line item', () {
      cubit.addToCart(testProduct1, selectedSize: 'M', quantity: 1);
      cubit.addToCart(testProduct2, quantity: 1);
      expect(cubit.state.items.length, 2);

      cubit.removeFromCart('prod_1', 'M');
      expect(cubit.state.items.length, 1);
      expect(cubit.state.items.first.product.id, 'prod_2');
    });

    test('clearCart empties all items', () {
      cubit.addToCart(testProduct1, selectedSize: 'M', quantity: 1);
      cubit.addToCart(testProduct2, quantity: 1);
      expect(cubit.state.items.length, 2);

      cubit.clearCart();
      expect(cubit.state.isEmpty, isTrue);
    });

    test('restoreItem re-inserts an item at the specified index', () {
      cubit.addToCart(testProduct1, selectedSize: 'M', quantity: 1);
      cubit.addToCart(testProduct2, quantity: 2);
      expect(cubit.state.items.length, 2);

      final removedItem = cubit.state.items.first;
      cubit.removeFromCart('prod_1', 'M');
      expect(cubit.state.items.length, 1);

      cubit.restoreItem(0, removedItem);
      expect(cubit.state.items.length, 2);
      expect(cubit.state.items.first.product.id, 'prod_1');
    });

    test('calculates totalOriginalPrice and totalSavings accurately', () {
      // testProduct1: price 1200, 1.25 markup = 1500, savings = 300
      cubit.addToCart(testProduct1, selectedSize: 'M', quantity: 1);

      expect(cubit.state.subtotal, 1200.0);
      expect(cubit.state.totalOriginalPrice, 1500.0);
      expect(cubit.state.totalSavings, 300.0);
    });

    test(
      'isolates carts between different users and merges guest items',
      () async {
        const userA = UserModel(
          uid: 'user_a',
          email: 'usera@example.com',
          displayName: 'User A',
        );
        const userB = UserModel(
          uid: 'user_b',
          email: 'userb@example.com',
          displayName: 'User B',
        );

        // Guest adds product 1
        cubit.addToCart(testProduct1, selectedSize: 'M', quantity: 1);
        expect(cubit.state.items.length, 1);

        // User A logs in -> guest item merges into User A's cart
        await cubit.setCustomer(userA);
        expect(cubit.state.items.length, 1);
        expect(cubit.state.items.first.product.id, 'prod_1');

        // User A adds product 2
        cubit.addToCart(testProduct2, quantity: 2);
        expect(cubit.state.items.length, 2);

        // User A logs out
        await cubit.setCustomer(null);
        // Guest cart was cleared upon merge, so guest sees 0 items
        expect(cubit.state.items.isEmpty, isTrue);

        // User B logs in -> User B has empty cart (never sees User A's items)
        await cubit.setCustomer(userB);
        expect(cubit.state.items.isEmpty, isTrue);

        // User B adds product 2 with quantity 1
        cubit.addToCart(testProduct2, quantity: 1);
        expect(cubit.state.items.length, 1);
        expect(cubit.state.items.first.quantity, 1);

        // User A logs back in -> sees their own 2 items
        await cubit.setCustomer(userA);
        expect(cubit.state.items.length, 2);
        expect(
          cubit.state.items
              .firstWhere((i) => i.product.id == 'prod_2')
              .quantity,
          2,
        );
      },
    );
  });
}
