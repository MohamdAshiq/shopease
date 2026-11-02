import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../dashboard/constants/dashboard_constants.dart';
import '../../../dashboard/widgets/components/admin_table_pagination.dart';
import '../../../dashboard/widgets/components/dashboard_card.dart';
import '../../cubits/admin_customers_cubit.dart';
import '../../cubits/admin_customers_state.dart';
import '../../models/customer_view_model.dart';
import 'customer_table_empty_state.dart';
import 'customer_table_header.dart';
import 'customer_table_row_builder.dart';

// Responsive Data Table for customers management
class CustomersDataTable extends StatelessWidget {
  const CustomersDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCustomersCubit, AdminCustomersState>(
      builder: (context, state) {
        final cubit = context.read<AdminCustomersCubit>();
        final paginated = state.paginatedCustomers;
        final totalCount = state.filteredCustomers.length;
        final int activeFilterCount =
            (state.searchQuery.trim().isNotEmpty ? 1 : 0) +
            (state.tierFilter != CustomerTierFilter.all ? 1 : 0) +
            (state.sortBy != CustomerSortBy.spendHighToLow ? 1 : 0);
        final hasFilters = activeFilterCount > 0;

        return DashboardCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Table Header Bar
              CustomerTableHeader(
                totalCount: totalCount,
                hasFilters: hasFilters,
                activeFilterCount: activeFilterCount,
                onResetFilters: cubit.resetFilters,
              ),

              const Divider(height: 1, thickness: 1, color: AppColors.divider),

              // Table Body (Empty or Data Rows)
              if (paginated.isEmpty)
                CustomerTableEmptyState(
                  isStoreEmpty: state.customers.isEmpty,
                  onResetFilters: cubit.resetFilters,
                )
              else
                _buildTableView(
                  context,
                  paginated,
                  state.selectedCustomerId,
                  cubit,
                ),

              const Divider(height: 1, thickness: 1, color: AppColors.divider),

              // Pagination Footer
              if (totalCount > 0)
                AdminTablePagination(
                  currentPage: state.currentPage,
                  totalPages: state.totalPages,
                  totalItems: totalCount,
                  itemsPerPage: state.itemsPerPage,
                  onPageChanged: cubit.changePage,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTableView(
    BuildContext context,
    List<CustomerViewModel> paginated,
    String? selectedCustomerId,
    AdminCustomersCubit cubit,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            constraints.maxWidth < DashboardConstants.customersTableMinWidth
            ? DashboardConstants.customersTableMinWidth
            : constraints.maxWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: width,
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(3.0), // Customer
                1: FlexColumnWidth(2.8), // Contact
                2: FlexColumnWidth(1.5), // Orders
                3: FlexColumnWidth(1.7), // Total Spend (LTV)
                4: FlexColumnWidth(1.5), // Tier
                5: FlexColumnWidth(1.0), // Actions
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                CustomerTableRowBuilder.buildHeader(),
                ...paginated.asMap().entries.map((entry) {
                  return CustomerTableRowBuilder.buildRow(
                    context: context,
                    customer: entry.value,
                    cubit: cubit,
                    isSelected: selectedCustomerId == entry.value.id,
                    isEven: entry.key.isEven,
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
