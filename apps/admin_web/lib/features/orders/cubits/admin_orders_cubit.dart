import 'dart:async';

import 'package:shopease_core/shopease_core.dart';

import 'admin_orders_state.dart';

// Cubit managing admin orders operations
class AdminOrdersCubit extends Cubit<AdminOrdersState> {
  AdminOrdersCubit({
    List<OrderModel>? initialOrders,
    OrderRepository? orderRepository,
  }) : _orderRepository = orderRepository ?? FirestoreOrderRepository(),
       super(AdminOrdersState(orders: initialOrders ?? const []));

  final OrderRepository _orderRepository;
  StreamSubscription<List<OrderModel>>? _ordersSubscription;

  // Stream live orders from Firestore
  void loadOrders() {
    emit(state.copyWith(isLoading: state.orders.isEmpty, errorMessage: null));
    _ordersSubscription?.cancel();

    _ordersSubscription = _orderRepository.watchAllOrders().listen(
      (orders) {
        if (!isClosed) {
          emit(state.copyWith(orders: orders, isLoading: false));
        }
      },
      onError: (e) {
        if (!isClosed) {
          emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
        }
      },
    );
  }

  // Search filter
  void search(String query) {
    emit(state.copyWith(searchQuery: query, currentPage: 1));
  }

  // Status tab filter
  void filterByStatus(OrderStatusFilter filter) {
    emit(state.copyWith(statusFilter: filter, currentPage: 1));
  }

  // Payment method filter
  void filterByPayment(PaymentMethodFilter filter) {
    emit(state.copyWith(paymentFilter: filter, currentPage: 1));
  }

  // Sort order
  void changeSort(OrderSortBy sort) {
    emit(state.copyWith(sortBy: sort, currentPage: 1));
  }

  // Pagination navigation
  void changePage(int page) {
    if (page >= 1 && page <= state.totalPages) {
      emit(state.copyWith(currentPage: page));
    }
  }

  // Select order for inspection drawer
  void selectOrder(String? orderId) {
    emit(
      orderId == null
          ? state.copyWith(clearSelectedOrder: true)
          : state.copyWith(selectedOrderId: orderId),
    );
  }

  // Close inspection drawer
  void closeDetailsDrawer() {
    emit(state.copyWith(clearSelectedOrder: true));
  }

  // Transition order fulfillment status in Firestore & state
  Future<void> updateOrderStatus(
    String orderId,
    OrderStatus newStatus, {
    String? note,
  }) async {
    final now = DateTime.now();
    final defaultNote = switch (newStatus) {
      OrderStatus.pending => 'Marked as Pending',
      OrderStatus.processing => 'Payment verified and packing started',
      OrderStatus.shipped => 'Dispatched with logistics carrier',
      OrderStatus.delivered => 'Delivered to recipient',
      OrderStatus.cancelled => note ?? 'Order cancelled by administrator',
    };

    final finalNote = note ?? defaultNote;

    // Optimistic local update
    final updatedOrders = state.orders.map((order) {
      if (order.id != orderId) return order;

      final newHistory = [
        ...order.statusHistory,
        OrderStatusHistory(
          status: newStatus.value,
          timestamp: now,
          note: finalNote,
        ),
      ];

      return order.copyWith(
        status: newStatus.value,
        statusHistory: newHistory,
        updatedAt: now,
      );
    }).toList();

    emit(state.copyWith(orders: updatedOrders));

    // Persist to Cloud Firestore
    try {
      await _orderRepository.updateOrderStatus(
        orderId: orderId,
        status: newStatus.value,
        note: finalNote,
      );
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(errorMessage: 'Failed to update order #$orderId: $e'),
        );
      }
    }
  }

  // Reset all search and filter parameters
  void resetFilters() {
    emit(
      state.copyWith(
        searchQuery: '',
        statusFilter: OrderStatusFilter.all,
        paymentFilter: PaymentMethodFilter.all,
        sortBy: OrderSortBy.newest,
        currentPage: 1,
      ),
    );
  }

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }
}
