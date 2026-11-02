import 'dart:async';

import 'package:customer_mobile/features/cart/cubits/cart_cubit.dart';
import 'package:customer_mobile/features/checkout/cubits/checkout_cubit.dart';
import 'package:customer_mobile/features/orders/cubits/order_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopease_core/shopease_core.dart';

class _FakeOrderRepository implements OrderRepository {
  final List<OrderModel> orders = [];
  final _controller = StreamController<List<OrderModel>>.broadcast();

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    orders.insert(0, order);
    _controller.add(List.unmodifiable(orders));
    return order;
  }

  @override
  Stream<List<OrderModel>> watchCustomerOrders(String customerId) {
    return _controller.stream.map(
      (list) => list.where((o) => o.customerId == customerId).toList(),
    );
  }

  @override
  Stream<List<OrderModel>> watchAllOrders() => _controller.stream;

  @override
  Future<OrderModel?> getOrderById(String orderId) async {
    return orders.where((o) => o.id == orderId).firstOrNull;
  }

  @override
  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
    String? note,
  }) async {
    final idx = orders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      orders[idx] = orders[idx].copyWith(status: status);
      _controller.add(List.unmodifiable(orders));
    }
  }

  @override
  Future<void> cancelOrder({required String orderId, String? reason}) async {
    await updateOrderStatus(
      orderId: orderId,
      status: 'cancelled',
      note: reason,
    );
  }

  void dispose() {
    _controller.close();
  }
}

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

  const realCustomer = UserModel(
    uid: 'real_cust_123',
    email: 'real@customer.com',
    displayName: 'Real Customer',
  );

  group('OrderCubit', () {
    late OrderCubit orderCubit;
    late CartCubit cartCubit;
    late _FakeOrderRepository fakeRepo;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      fakeRepo = _FakeOrderRepository();
      orderCubit = OrderCubit(orderRepository: fakeRepo);
      cartCubit = CartCubit();
    });

    tearDown(() {
      orderCubit.close();
      cartCubit.close();
      fakeRepo.dispose();
    });

    test(
      'initial state initializes with empty orders or custom initialOrders',
      () {
        expect(orderCubit.state.orders.isEmpty, isTrue);
        expect(orderCubit.state.isLoading, isFalse);

        final populatedCubit = OrderCubit(
          initialOrders: [
            const OrderModel(
              id: 'ORD-TEST-1',
              customerId: 'cust_1',
              customerName: 'Test',
              customerEmail: 'test@example.com',
              items: [],
              deliveryAddress: testAddress,
              subtotal: 100,
              deliveryFee: 10,
              total: 110,
            ),
          ],
        );
        expect(populatedCubit.state.orders.length, 1);
        populatedCubit.close();
      },
    );

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

    test('placeOrder with real customer persists to repository without leaking mock data', () async {
      cartCubit.addToCart(testProduct1, selectedSize: '9', quantity: 1);

      final placed = await orderCubit.placeOrder(
        address: testAddress,
        cartItems: cartCubit.state.items,
        subtotal: cartCubit.state.subtotal,
        deliveryFee: cartCubit.state.deliveryFee,
        total: cartCubit.state.total,
        paymentMethod: PaymentMethodType.upi,
        customer: realCustomer,
      );

      expect(placed.customerId, realCustomer.uid);
      expect(placed.customerEmail, realCustomer.email);
      expect(fakeRepo.orders.length, 1);
      expect(fakeRepo.orders.first.id, placed.id);
    });

    test('cancelOrder updates order status to cancelled', () async {
      cartCubit.addToCart(testProduct1, selectedSize: '9', quantity: 1);
      final placed = await orderCubit.placeOrder(
        address: testAddress,
        cartItems: cartCubit.state.items,
        subtotal: cartCubit.state.subtotal,
        deliveryFee: cartCubit.state.deliveryFee,
        total: cartCubit.state.total,
        paymentMethod: PaymentMethodType.upi,
      );

      await orderCubit.cancelOrder(placed.id);
      final cancelled = orderCubit.state.findById(placed.id);
      expect(cancelled?.status, 'cancelled');
    });

    test(
      'setCustomer switches to customer stream or clears on logout',
      () async {
        orderCubit.setCustomer(realCustomer);
        expect(orderCubit.state.isLoading, isTrue);

        orderCubit.setCustomer(null);
        expect(orderCubit.state.orders.isEmpty, isTrue);
        expect(orderCubit.state.isLoading, isFalse);
      },
    );
  });

  group('CheckoutCubit', () {
    late CheckoutCubit checkoutCubit;
    late OrderCubit orderCubit;
    late CartCubit cartCubit;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      checkoutCubit = CheckoutCubit(initialAddress: testAddress);
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

    test('initial state with null address is invalid', () {
      final unaddressedCubit = CheckoutCubit();
      expect(unaddressedCubit.state.isAddressValid, isFalse);
      unaddressedCubit.close();
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
