import 'package:shopease_core/shopease_core.dart';

import '../models/customer_view_model.dart';
import '../models/mock_customers.dart';
import 'admin_customers_state.dart';

// Cubit managing Customers Module
class AdminCustomersCubit extends Cubit<AdminCustomersState> {
  AdminCustomersCubit({List<CustomerViewModel>? initialCustomers})
    : super(
        AdminCustomersState(
          customers: initialCustomers ?? generateMockCustomers(mockOrders),
        ),
      );

  // Search filter
  void search(String query) {
    emit(state.copyWith(searchQuery: query, currentPage: 1));
  }

  // Tier filter
  void filterByTier(CustomerTierFilter filter) {
    emit(state.copyWith(tierFilter: filter, currentPage: 1));
  }

  // Sort order
  void changeSort(CustomerSortBy sort) {
    emit(state.copyWith(sortBy: sort, currentPage: 1));
  }

  // Pagination navigation
  void changePage(int page) {
    if (page >= 1 && page <= state.totalPages) {
      emit(state.copyWith(currentPage: page));
    }
  }

  // Select customer for inspector drawer
  void selectCustomer(String? customerId) {
    emit(
      customerId == null
          ? state.copyWith(clearSelectedCustomer: true)
          : state.copyWith(selectedCustomerId: customerId),
    );
  }

  // Close inspector drawer
  void closeDetailsDrawer() {
    emit(state.copyWith(clearSelectedCustomer: true));
  }

  // Reset all search and filter parameters
  void resetFilters() {
    emit(
      state.copyWith(
        searchQuery: '',
        tierFilter: CustomerTierFilter.all,
        sortBy: CustomerSortBy.spendHighToLow,
        currentPage: 1,
      ),
    );
  }
}
