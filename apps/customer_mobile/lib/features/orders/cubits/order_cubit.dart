import 'dart:math';

import 'package:shopease_core/shopease_core.dart';

import 'order_state.dart';

// Cubit fir managing orders
class OrderCubit extends Cubit<OrderState> {
  OrderCubit({List<OrderModel>? initialOrders})
    : super(
        OrderState(
          orders: initialOrders ?? List<OrderModel>.from(mockOrders),
          isLoading: false,
        ),
      );

  // Place a new order from cart checkout
  Future<OrderModel> placeOrder({
    required CustomerAddressModel address,
    required List<CartItemModel> cartItems,
    required double subtotal,
    required double deliveryFee,
    required double total,
    required PaymentMethodType paymentMethod,
  }) async {
    final now = DateTime.now();
    final datePart =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final randomSuffix = (1000 + Random().nextInt(9000)).toString();
    final orderId = 'ORD-$datePart-$randomSuffix';

    final paymentTitle = paymentMethod.title;

    final newOrder = OrderModel(
      id: orderId,
      customerId: mockCustomer.uid,
      customerName: address.recipientName?.isNotEmpty == true
          ? address.recipientName!
          : mockCustomer.displayName,
      customerEmail: mockCustomer.email,
      customerPhone: address.phone?.isNotEmpty == true
          ? address.phone!
          : (mockCustomer.address?.phone ?? mockCustomer.phone),
      items: cartItems.map((c) => c.toOrderItem()).toList(),
      deliveryAddress: address,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: total,
      paymentMethod: paymentMethod,
      status: 'pending',
      statusHistory: [
        OrderStatusHistory(
          status: 'pending',
          timestamp: now,
          note: 'Order placed successfully with $paymentTitle',
        ),
      ],
      createdAt: now,
      updatedAt: now,
    );

    final updatedOrders = [newOrder, ...state.orders];
    if (!isClosed) {
      emit(state.copyWith(orders: updatedOrders, isLoading: false));
    }
    return newOrder;
  }

  // Cancel order if pending or processing
  Future<void> cancelOrder(String orderId) async {
    final updatedOrders = state.orders.map((order) {
      if (order.id == orderId) {
        final newHistory = [
          ...order.statusHistory,
          OrderStatusHistory(
            status: 'cancelled',
            timestamp: DateTime.now(),
            note: 'Order cancelled by customer',
          ),
        ];
        return order.copyWith(
          status: 'cancelled',
          statusHistory: newHistory,
          updatedAt: DateTime.now(),
        );
      }
      return order;
    }).toList();

    if (!isClosed) {
      emit(state.copyWith(orders: updatedOrders));
    }
  }
}
