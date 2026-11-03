import 'package:shopease_core/shopease_core.dart';

// Filter tabs for Orders screen
enum OrderFilterType {
  all('All'),
  inProgress('In Progress'),
  delivered('Delivered'),
  cancelled('Cancelled');

  const OrderFilterType(this.label);
  final String label;

  bool matches(OrderModel order) {
    switch (this) {
      case OrderFilterType.all:
        return true;
      case OrderFilterType.inProgress:
        return order.status == 'pending' ||
            order.status == 'processing' ||
            order.status == 'shipped';
      case OrderFilterType.delivered:
        return order.status == 'delivered';
      case OrderFilterType.cancelled:
        return order.status == 'cancelled';
    }
  }
}

// State for managing orders
class OrderState extends Equatable {
  const OrderState({
    this.orders = const [],
    this.isLoading = false,
    this.selectedFilter = OrderFilterType.all,
    this.error,
  });

  final List<OrderModel> orders;
  final bool isLoading;
  final OrderFilterType selectedFilter;
  final String? error;

  List<OrderModel> get filteredOrders =>
      orders.where(selectedFilter.matches).toList();

  OrderModel? findById(String id) {
    try {
      return orders.firstWhere((order) => order.id == id);
    } catch (_) {
      return null;
    }
  }

  OrderState copyWith({
    List<OrderModel>? orders,
    bool? isLoading,
    OrderFilterType? selectedFilter,
    String? error,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      error: error,
    );
  }

  @override
  List<Object?> get props => [orders, isLoading, selectedFilter, error];
}
