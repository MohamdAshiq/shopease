import 'dart:async';
import 'dart:math';

import 'package:shopease_core/shopease_core.dart';

import 'order_state.dart';

// Cubit for managing orders with real-time synchronization
class OrderCubit extends Cubit<OrderState> {
  OrderCubit({
    UserModel? initialCustomer,
    List<OrderModel>? initialOrders,
    OrderRepository? orderRepository,
  }) : _orderRepository = orderRepository ?? FirestoreOrderRepository(),
       super(OrderState(orders: initialOrders ?? const [], isLoading: false)) {
    if (initialCustomer != null) {
      setCustomer(initialCustomer);
    }
  }

  final OrderRepository _orderRepository;
  StreamSubscription<List<OrderModel>>? _ordersSubscription;

  // Set active filter
  void setFilter(OrderFilterType filter) {
    if (state.selectedFilter == filter) return;
    emit(state.copyWith(selectedFilter: filter));
  }

  // Listen to customer orders
  void setCustomer(UserModel? user) {
    _ordersSubscription?.cancel();

    if (user == null) {
      emit(state.copyWith(orders: const [], isLoading: false));
      return;
    }

    emit(state.copyWith(isLoading: true));
    _ordersSubscription = _orderRepository
        .watchCustomerOrders(user.uid)
        .listen(
          (orders) {
            if (!isClosed) {
              emit(state.copyWith(orders: orders, isLoading: false));
            }
          },
          onError: (_) {
            if (!isClosed) {
              emit(state.copyWith(isLoading: false));
            }
          },
        );
  }

  // Place a new order from cart checkout
  Future<OrderModel> placeOrder({
    required CustomerAddressModel address,
    required List<CartItemModel> cartItems,
    required double subtotal,
    required double deliveryFee,
    required double total,
    required PaymentMethodType paymentMethod,
    UserModel? customer,
  }) async {
    final now = DateTime.now();
    final datePart =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final randomSuffix = (1000 + Random().nextInt(9000)).toString();
    final orderId = 'ORD-$datePart-$randomSuffix';

    final customerId = customer?.uid ?? '';
    final String customerName = address.recipientName?.trim().isNotEmpty == true
        ? address.recipientName!.trim()
        : (customer?.displayName.trim().isNotEmpty == true
              ? customer!.displayName.trim()
              : (customer?.email.isNotEmpty == true
                    ? customer!.email.split('@').first
                    : 'Customer'));
    final String customerEmail = customer?.email ?? '';
    final String customerPhone = address.phone?.trim().isNotEmpty == true
        ? address.phone!.trim()
        : (customer?.phone.trim().isNotEmpty == true
              ? customer!.phone.trim()
              : '');

    final paymentTitle = paymentMethod.title;

    final newOrder = OrderModel(
      id: orderId,
      customerId: customerId,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      items: cartItems.map((c) => c.toOrderItem()).toList(),
      deliveryAddress: address,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: total,
      paymentMethod: paymentMethod,
      status: OrderStatus.pending.value,
      statusHistory: [
        OrderStatusHistory(
          status: OrderStatus.pending.value,
          timestamp: now,
          note: 'Order placed successfully with $paymentTitle',
        ),
      ],
      createdAt: now,
      updatedAt: now,
    );

    // Persist to Cloud Firestore
    try {
      await _orderRepository.createOrder(newOrder);
    } catch (_) {}

    final updatedOrders = [
      newOrder,
      ...state.orders.where((o) => o.id != orderId),
    ];
    if (!isClosed) {
      emit(state.copyWith(orders: updatedOrders, isLoading: false));
    }
    return newOrder;
  }

  // Cancel order if pending or processing
  Future<void> cancelOrder(String orderId) async {
    try {
      await _orderRepository.cancelOrder(orderId: orderId);
    } catch (_) {
      // Local fallback
    }

    final updatedOrders = state.orders.map((order) {
      if (order.id == orderId) {
        final newHistory = [
          ...order.statusHistory,
          OrderStatusHistory(
            status: OrderStatus.cancelled.value,
            timestamp: DateTime.now(),
            note: 'Order cancelled by customer',
          ),
        ];
        return order.copyWith(
          status: OrderStatus.cancelled.value,
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

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }
}
