import 'package:shopease_core/shopease_core.dart';

// State for managing orders
class OrderState extends Equatable {
  const OrderState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
  });

  final List<OrderModel> orders;
  final bool isLoading;
  final String? error;

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
    String? error,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [orders, isLoading, error];
}
