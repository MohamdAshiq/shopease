import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../dashboard/constants/dashboard_constants.dart';
import '../../../dashboard/widgets/components/admin_table_pagination.dart';
import '../../../dashboard/widgets/components/dashboard_card.dart';
import '../../cubits/admin_orders_cubit.dart';
import '../../cubits/admin_orders_state.dart';
import 'order_table_row_builder.dart';
import 'orders_table_empty_state.dart';
import 'orders_table_header.dart';

// Data Table for orders management
class OrdersDataTable extends StatelessWidget {
  const OrdersDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminOrdersCubit, AdminOrdersState>(
      builder: (context, state) {
        final cubit = context.read<AdminOrdersCubit>();
        final paginated = state.paginatedOrders;
        final totalCount = state.filteredOrders.length;
        final int activeFilterCount =
            (state.searchQuery.trim().isNotEmpty ? 1 : 0) +
            (state.statusFilter != OrderStatusFilter.all ? 1 : 0) +
            (state.paymentFilter != PaymentMethodFilter.all ? 1 : 0) +
            (state.sortBy != OrderSortBy.newest ? 1 : 0);
        final hasFilters = activeFilterCount > 0;

        return DashboardCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Table Header Bar
              OrdersTableHeader(
                totalCount: totalCount,
                hasFilters: hasFilters,
                activeFilterCount: activeFilterCount,
                onResetFilters: cubit.resetFilters,
              ),

              const Divider(height: 1, thickness: 1, color: AppColors.divider),

              // Table Body (Empty or Data Rows)
              if (paginated.isEmpty)
                OrdersTableEmptyState(
                  isStoreEmpty: state.orders.isEmpty,
                  onResetFilters: cubit.resetFilters,
                )
              else
                _buildTableView(
                  context,
                  paginated,
                  state.selectedOrderId,
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
    List<OrderModel> paginated,
    String? selectedOrderId,
    AdminOrdersCubit cubit,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            constraints.maxWidth < DashboardConstants.ordersTableMinWidth
            ? DashboardConstants.ordersTableMinWidth
            : constraints.maxWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: width,
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2.4), // Order ID + Date
                1: FlexColumnWidth(2.2), // Customer
                2: FlexColumnWidth(2.8), // Items preview
                3: FlexColumnWidth(1.4), // Total
                4: FlexColumnWidth(1.5), // Payment
                5: FlexColumnWidth(1.6), // Status
                6: FlexColumnWidth(1.2), // Actions
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                OrderTableRowBuilder.buildHeader(),
                ...paginated.asMap().entries.map((entry) {
                  return OrderTableRowBuilder.buildRow(
                    context: context,
                    order: entry.value,
                    cubit: cubit,
                    isSelected: selectedOrderId == entry.value.id,
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
