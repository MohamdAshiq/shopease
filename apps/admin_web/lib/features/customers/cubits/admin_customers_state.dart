import 'package:shopease_core/shopease_core.dart';

import '../../dashboard/constants/dashboard_constants.dart';
import '../models/customer_view_model.dart';

// Customer Segment Filters
enum CustomerTierFilter {
  all('All Customers'),
  vip('VIP'),
  active('Active Buyers'),
  newCustomer('New Customers'),
  inactive('Inactive');

  const CustomerTierFilter(this.label);
  final String label;
}

// Customer Sorting Options
enum CustomerSortBy {
  spendHighToLow('Spend: High to Low'),
  spendLowToHigh('Spend: Low to High'),
  ordersHighToLow('Most Orders'),
  newestJoined('Newest Joined'),
  nameAZ('Name: A to Z');

  const CustomerSortBy(this.label);
  final String label;
}

// Admin Customers State
class AdminCustomersState extends Equatable {
  const AdminCustomersState({
    required this.customers,
    this.searchQuery = '',
    this.tierFilter = CustomerTierFilter.all,
    this.sortBy = CustomerSortBy.spendHighToLow,
    this.currentPage = 1,
    this.itemsPerPage = DashboardConstants.defaultCustomersPerPage,
    this.selectedCustomerId,
  });

  final List<CustomerViewModel> customers;
  final String searchQuery;
  final CustomerTierFilter tierFilter;
  final CustomerSortBy sortBy;
  final int currentPage;
  final int itemsPerPage;
  final String? selectedCustomerId;

  // Currently selected customer for the slide-over inspector
  CustomerViewModel? get selectedCustomer {
    if (selectedCustomerId == null) return null;
    try {
      return customers.firstWhere((c) => c.id == selectedCustomerId);
    } catch (_) {
      return null;
    }
  }

  // Search & filter computation
  List<CustomerViewModel> get filteredCustomers {
    var result = List<CustomerViewModel>.from(customers);

    // Search query filter
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      result = result.where((c) {
        final matchName = c.name.toLowerCase().contains(q);
        final matchEmail = c.email.toLowerCase().contains(q);
        final matchPhone = c.phone.toLowerCase().contains(q);
        final matchCity = c.address?.city.toLowerCase().contains(q) ?? false;
        final matchState = c.address?.state.toLowerCase().contains(q) ?? false;
        return matchName || matchEmail || matchPhone || matchCity || matchState;
      }).toList();
    }

    // Tier segment filter
    if (tierFilter != CustomerTierFilter.all) {
      result = result.where((c) {
        switch (tierFilter) {
          case CustomerTierFilter.vip:
            return c.tier == CustomerTier.vip;
          case CustomerTierFilter.active:
            return c.tier == CustomerTier.active;
          case CustomerTierFilter.newCustomer:
            return c.tier == CustomerTier.newCustomer;
          case CustomerTierFilter.inactive:
            return c.tier == CustomerTier.inactive;
          case CustomerTierFilter.all:
            return true;
        }
      }).toList();
    }

    // Sorting
    switch (sortBy) {
      case CustomerSortBy.spendHighToLow:
        result.sort((a, b) => b.lifetimeValue.compareTo(a.lifetimeValue));
      case CustomerSortBy.spendLowToHigh:
        result.sort((a, b) => a.lifetimeValue.compareTo(b.lifetimeValue));
      case CustomerSortBy.ordersHighToLow:
        result.sort((a, b) => b.orderCount.compareTo(a.orderCount));
      case CustomerSortBy.newestJoined:
        result.sort((a, b) => b.joinedAt.compareTo(a.joinedAt));
      case CustomerSortBy.nameAZ:
        result.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
    }

    return result;
  }

  // Paginated slice of filtered customers
  List<CustomerViewModel> get paginatedCustomers {
    final list = filteredCustomers;
    final startIndex = (currentPage - 1) * itemsPerPage;
    if (startIndex >= list.length) {
      if (list.isEmpty) return const [];
      return list.take(itemsPerPage).toList();
    }
    return list.skip(startIndex).take(itemsPerPage).toList();
  }

  int get totalPages {
    final total = filteredCustomers.length;
    if (total == 0) return 1;
    return (total / itemsPerPage).ceil();
  }

  // Executive KPI summary metrics
  int get totalCustomersCount => customers.length;

  int get activeBuyersCount => customers.where((c) => c.orderCount > 0).length;

  int get vipCount => customers.where((c) => c.tier == CustomerTier.vip).length;

  int get newCount =>
      customers.where((c) => c.tier == CustomerTier.newCustomer).length;

  int get inactiveCount =>
      customers.where((c) => c.tier == CustomerTier.inactive).length;

  double get averageLtv {
    final buyers = customers.where((c) => c.orderCount > 0);
    if (buyers.isEmpty) return 0.0;
    final totalRevenue = buyers.fold<double>(
      0.0,
      (sum, c) => sum + c.lifetimeValue,
    );
    return totalRevenue / buyers.length;
  }

  AdminCustomersState copyWith({
    List<CustomerViewModel>? customers,
    String? searchQuery,
    CustomerTierFilter? tierFilter,
    CustomerSortBy? sortBy,
    int? currentPage,
    int? itemsPerPage,
    String? selectedCustomerId,
    bool clearSelectedCustomer = false,
  }) {
    return AdminCustomersState(
      customers: customers ?? this.customers,
      searchQuery: searchQuery ?? this.searchQuery,
      tierFilter: tierFilter ?? this.tierFilter,
      sortBy: sortBy ?? this.sortBy,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      selectedCustomerId: clearSelectedCustomer
          ? null
          : (selectedCustomerId ?? this.selectedCustomerId),
    );
  }

  @override
  List<Object?> get props => [
    customers,
    searchQuery,
    tierFilter,
    sortBy,
    currentPage,
    itemsPerPage,
    selectedCustomerId,
  ];
}
