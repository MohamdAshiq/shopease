import 'package:customer_mobile/features/cart/cubits/cart_cubit.dart';
import 'package:customer_mobile/features/checkout/cubits/checkout_cubit.dart';
import 'package:customer_mobile/features/orders/cubits/order_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopease_core/shopease_core.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testProduct1 = ProductModel(
    id: 'prod_test_1',
    title: 'Test Running Shoes',
    description: 'Comfortable sports shoes',
    price: 1500.0,
    stock: 10,
    category: 'Footwear',
    imageUrl: 'https://example.com/shoes.jpg',
  );

  const testAddress = CustomerAddressModel(
    recipientName: 'Test Recipient',
    phone: '+91 9988776655',
    street: '123 Test Street, Apartment 4B',
    city: 'Bengaluru',
    state: 'Karnataka',
    postalCode: '560001',
    country: 'India',
  );

  group('OrderCubit', () {
    late OrderCubit orderCubit;
    late CartCubit cartCubit;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      orderCubit = OrderCubit();
      cartCubit = CartCubit();
    });

    tearDown(() {
      orderCubit.close();
      cartCubit.close();
    });

    test('initial state initializes with mockOrders', () {
      expect(orderCubit.state.orders.isNotEmpty, isTrue);
      expect(orderCubit.state.orders.length, mockOrders.length);
      expect(orderCubit.state.isLoading, isFalse);
    });

    test('placeOrder creates order with valid items and history', () async {
      cartCubit.addToCart(testProduct1, selectedSize: '9', quantity: 2);

      final placed = await orderCubit.placeOrder(
        address: testAddress,
        cartItems: cartCubit.state.items,
        subtotal: cartCubit.state.subtotal,
        deliveryFee: cartCubit.state.deliveryFee,
        total: cartCubit.state.total,
        paymentMethod: PaymentMethodType.upi,
      );

      expect(placed.id.startsWith('ORD-'), isTrue);
      expect(placed.items.length, 1);
      expect(placed.items.first.title, contains('Test Running Shoes (9)'));
      expect(placed.total, 3000.0);
      expect(placed.status, 'pending');
      expect(placed.statusHistory.length, 1);
      expect(orderCubit.state.orders.first.id, placed.id);
    });

    test('cancelOrder updates order status to cancelled', () async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      final firstId = orderCubit.state.orders.first.id;

      await orderCubit.cancelOrder(firstId);
      final cancelled = orderCubit.state.findById(firstId);
      expect(cancelled?.status, 'cancelled');
    });
  });

  group('CheckoutCubit', () {
    late CheckoutCubit checkoutCubit;
    late OrderCubit orderCubit;
    late CartCubit cartCubit;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      checkoutCubit = CheckoutCubit();
      orderCubit = OrderCubit();
      cartCubit = CartCubit();
    });

    tearDown(() {
      checkoutCubit.close();
      orderCubit.close();
      cartCubit.close();
    });

    test('initial state has default address and payment method', () {
      expect(checkoutCubit.state.paymentMethod, PaymentMethodType.upi);
      expect(checkoutCubit.state.isAddressValid, isTrue);
      expect(checkoutCubit.state.isSubmitting, isFalse);
      expect(checkoutCubit.state.isSuccess, isFalse);
    });

    test('updateAddress and selectPaymentMethod mutate state', () {
      checkoutCubit.selectPaymentMethod(PaymentMethodType.cod);
      expect(checkoutCubit.state.paymentMethod, PaymentMethodType.cod);

      const modifiedAddress = CustomerAddressModel(
        street: '456 New Road',
        city: 'Mumbai',
        state: 'Maharashtra',
        postalCode: '400001',
        country: 'India',
        recipientName: 'Alex M',
      );
      checkoutCubit.updateAddress(modifiedAddress);
      expect(checkoutCubit.state.address.city, 'Mumbai');
    });

    test('placeOrder prevents submission when cart is empty', () async {
      expect(cartCubit.state.isEmpty, isTrue);

      final result = await checkoutCubit.placeOrder(
        orderCubit: orderCubit,
        cartCubit: cartCubit,
      );

      expect(result, isNull);
      expect(checkoutCubit.state.errorMessage, 'Your cart is empty.');
    });

    test('placeOrder succeeds, persists order and clears cart', () async {
      cartCubit.addToCart(testProduct1, selectedSize: '8', quantity: 1);
      expect(cartCubit.state.items.length, 1);

      final result = await checkoutCubit.placeOrder(
        orderCubit: orderCubit,
        cartCubit: cartCubit,
      );

      expect(result, isNotNull);
      expect(checkoutCubit.state.isSuccess, isTrue);
      expect(checkoutCubit.state.placedOrder?.id, result?.id);
      // Cart should now be cleared
      expect(cartCubit.state.isEmpty, isTrue);
    });
  });
}
