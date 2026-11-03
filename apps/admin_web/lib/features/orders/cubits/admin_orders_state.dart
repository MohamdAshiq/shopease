import 'package:shopease_core/shopease_core.dart';

import '../../dashboard/constants/dashboard_constants.dart';

// Status filter options
enum OrderStatusFilter {
  all,
  pending,
  processing,
  shipped,
  delivered,
  cancelled;

  String get label {
    switch (this) {
      case OrderStatusFilter.all:
        return 'All';
      case OrderStatusFilter.pending:
        return 'Pending';
      case OrderStatusFilter.processing:
        return 'Processing';
      case OrderStatusFilter.shipped:
        return 'Shipped';
      case OrderStatusFilter.delivered:
        return 'Delivered';
      case OrderStatusFilter.cancelled:
        return 'Cancelled';
    }
  }
}

// Payment method filter options
enum PaymentMethodFilter {
  all,
  upi,
  card,
  netbanking,
  cod;

  String get label {
    switch (this) {
      case PaymentMethodFilter.all:
        return 'All Payments';
      case PaymentMethodFilter.upi:
        return 'UPI';
      case PaymentMethodFilter.card:
        return 'Cards';
      case PaymentMethodFilter.netbanking:
        return 'Net Banking';
      case PaymentMethodFilter.cod:
        return 'Cash on Delivery';
    }
  }
}

// Order sorting options
enum OrderSortBy {
  newest,
  oldest,
  amountHighToLow,
  amountLowToHigh;

  String get label {
    switch (this) {
      case OrderSortBy.newest:
        return 'Newest First';
      case OrderSortBy.oldest:
        return 'Oldest First';
      case OrderSortBy.amountHighToLow:
        return 'Value: High to Low';
      case OrderSortBy.amountLowToHigh:
        return 'Value: Low to High';
    }
  }
}

// Orders management state
class AdminOrdersState extends Equatable {
  const AdminOrdersState({
    required this.orders,
    this.searchQuery = '',
    this.statusFilter = OrderStatusFilter.all,
    this.paymentFilter = PaymentMethodFilter.all,
    this.sortBy = OrderSortBy.newest,
    this.currentPage = 1,
    this.itemsPerPage = DashboardConstants.defaultOrdersPerPage,
    this.selectedOrderId,
    this.isLoading = false,
    this.errorMessage,
  });

  final List<OrderModel> orders;
  final String searchQuery;
  final OrderStatusFilter statusFilter;
  final PaymentMethodFilter paymentFilter;
  final OrderSortBy sortBy;
  final int currentPage;
  final int itemsPerPage;
  final String? selectedOrderId;
  final bool isLoading;
  final String? errorMessage;

  // Selected order for side drawer
  OrderModel? get selectedOrder {
    if (selectedOrderId == null) return null;
    try {
      return orders.firstWhere((o) => o.id == selectedOrderId);
    } catch (_) {
      return null;
    }
  }

  // Filtered orders list
  List<OrderModel> get filteredOrders {
    var result = List<OrderModel>.from(orders);

    // Search query filter
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      result = result.where((order) {
        final matchId = order.id.toLowerCase().contains(q);
        final matchName = order.customerName.toLowerCase().contains(q);
        final matchEmail = order.customerEmail.toLowerCase().contains(q);
        final matchPhone = order.customerPhone.toLowerCase().contains(q);
        final matchItems = order.items.any(
          (item) => item.title.toLowerCase().contains(q),
        );
        return matchId || matchName || matchEmail || matchPhone || matchItems;
      }).toList();
    }

    // Status filter
    if (statusFilter != OrderStatusFilter.all) {
      result = result.where((o) => o.status == statusFilter.name).toList();
    }

    // Payment method filter
    if (paymentFilter != PaymentMethodFilter.all) {
      result = result.where((o) {
        switch (paymentFilter) {
          case PaymentMethodFilter.upi:
            return o.paymentMethod == PaymentMethodType.upi;
          case PaymentMethodFilter.card:
            return o.paymentMethod == PaymentMethodType.card;
          case PaymentMethodFilter.netbanking:
            return o.paymentMethod == PaymentMethodType.netbanking;
          case PaymentMethodFilter.cod:
            return o.paymentMethod == PaymentMethodType.cod;
          case PaymentMethodFilter.all:
            return true;
        }
      }).toList();
    }

    // Sorting
    switch (sortBy) {
      case OrderSortBy.newest:
        result.sort((a, b) {
          final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bDate.compareTo(aDate);
        });
      case OrderSortBy.oldest:
        result.sort((a, b) {
          final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return aDate.compareTo(bDate);
        });
      case OrderSortBy.amountHighToLow:
        result.sort((a, b) => b.total.compareTo(a.total));
      case OrderSortBy.amountLowToHigh:
        result.sort((a, b) => a.total.compareTo(b.total));
    }

    return result;
  }

  // Total pages
  int get totalPages {
    final count = filteredOrders.length;
    if (count == 0) return 1;
    return (count / itemsPerPage).ceil();
  }

  // Orders for active page
  List<OrderModel> get paginatedOrders {
    final list = filteredOrders;
    final startIndex = (currentPage - 1) * itemsPerPage;
    if (startIndex >= list.length) return [];
    final endIndex = (startIndex + itemsPerPage).clamp(0, list.length);
    return list.sublist(startIndex, endIndex);
  }

  // Count metrics for toolbar and summary chips
  int get totalOrdersCount => orders.length;

  int get pendingCount =>
      orders.where((o) => o.status == OrderStatus.pending.value).length;

  int get processingCount =>
      orders.where((o) => o.status == OrderStatus.processing.value).length;

  int get shippedCount =>
      orders.where((o) => o.status == OrderStatus.shipped.value).length;

  int get deliveredCount =>
      orders.where((o) => o.status == OrderStatus.delivered.value).length;

  int get cancelledCount =>
      orders.where((o) => o.status == OrderStatus.cancelled.value).length;

  double get totalRevenue => orders
      .where((o) => o.status != OrderStatus.cancelled.value)
      .fold<double>(0.0, (sum, o) => sum + o.total);

  AdminOrdersState copyWith({
    List<OrderModel>? orders,
    String? searchQuery,
    OrderStatusFilter? statusFilter,
    PaymentMethodFilter? paymentFilter,
    OrderSortBy? sortBy,
    int? currentPage,
    int? itemsPerPage,
    String? selectedOrderId,
    bool clearSelectedOrder = false,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AdminOrdersState(
      orders: orders ?? this.orders,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      paymentFilter: paymentFilter ?? this.paymentFilter,
      sortBy: sortBy ?? this.sortBy,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      selectedOrderId: clearSelectedOrder
          ? null
          : (selectedOrderId ?? this.selectedOrderId),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    orders,
    searchQuery,
    statusFilter,
    paymentFilter,
    sortBy,
    currentPage,
    itemsPerPage,
    selectedOrderId,
    isLoading,
    errorMessage,
  ];
}
