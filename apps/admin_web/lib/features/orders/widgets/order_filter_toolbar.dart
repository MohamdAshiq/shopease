import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../dashboard/widgets/components/filter_dropdown_chip.dart';
import '../cubits/admin_orders_cubit.dart';
import '../cubits/admin_orders_state.dart';

// Filter toolbar for orders
class OrderFilterToolbar extends StatefulWidget {
  const OrderFilterToolbar({super.key});

  @override
  State<OrderFilterToolbar> createState() => _OrderFilterToolbarState();
}

class _OrderFilterToolbarState extends State<OrderFilterToolbar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminOrdersCubit, AdminOrdersState>(
      listenWhen: (prev, curr) => prev.searchQuery != curr.searchQuery,
      listener: (context, state) {
        if (_searchController.text != state.searchQuery) {
          _searchController.text = state.searchQuery;
        }
      },
      child: BlocBuilder<AdminOrdersCubit, AdminOrdersState>(
        builder: (context, state) {
          final cubit = context.read<AdminOrdersCubit>();

          return Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: AppColors.border, width: 1.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top row: Search input + Payment & Sort Dropdowns
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 750;

                    if (isMobile) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSearchBar(cubit),
                          const SizedBox(height: AppSizes.sm),
                          Wrap(
                            spacing: AppSizes.sm,
                            runSpacing: AppSizes.sm,
                            children: [
                              _buildPaymentDropdown(state, cubit),
                              _buildSortDropdown(state, cubit),
                            ],
                          ),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(flex: 3, child: _buildSearchBar(cubit)),
                        const SizedBox(width: AppSizes.md),
                        _buildPaymentDropdown(state, cubit),
                        const SizedBox(width: AppSizes.sm),
                        _buildSortDropdown(state, cubit),
                      ],
                    );
                  },
                ),

                const SizedBox(height: AppSizes.md),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.divider,
                ),
                const SizedBox(height: AppSizes.sm),

                // Bottom row: Operational Status Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: OrderStatusFilter.values.map((filter) {
                      final isSelected = state.statusFilter == filter;
                      final count = _getCountForStatus(state, filter);

                      return Padding(
                        padding: const EdgeInsets.only(right: AppSizes.sm),
                        child: _buildStatusChip(
                          filter: filter,
                          count: count,
                          isSelected: isSelected,
                          onTap: () => cubit.filterByStatus(filter),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(AdminOrdersCubit cubit) {
    return AppSearchBar(
      controller: _searchController,
      hintText: 'Search by Order ID, customer, phone or product...',
      fillColor: AppColors.surface,
      borderColor: AppColors.border,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      onChanged: cubit.search,
      onClear: () {
        _searchController.clear();
        cubit.search('');
      },
    );
  }

  Widget _buildPaymentDropdown(AdminOrdersState state, AdminOrdersCubit cubit) {
    return FilterDropdownChip<PaymentMethodFilter>(
      value: state.paymentFilter,
      isActive: state.paymentFilter != PaymentMethodFilter.all,
      items: PaymentMethodFilter.values.map((p) {
        return DropdownMenuItem(value: p, child: Text(p.label));
      }).toList(),
      onChanged: (val) {
        if (val != null) cubit.filterByPayment(val);
      },
    );
  }

  Widget _buildSortDropdown(AdminOrdersState state, AdminOrdersCubit cubit) {
    return FilterDropdownChip<OrderSortBy>(
      value: state.sortBy,
      isActive: state.sortBy != OrderSortBy.newest,
      items: OrderSortBy.values.map((s) {
        return DropdownMenuItem(value: s, child: Text(s.label));
      }).toList(),
      onChanged: (val) {
        if (val != null) cubit.changeSort(val);
      },
    );
  }

  Widget _buildStatusChip({
    required OrderStatusFilter filter,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final Color accentColor = switch (filter) {
      OrderStatusFilter.all => AppColors.primary,
      OrderStatusFilter.pending => AppColors.warning,
      OrderStatusFilter.processing => AppColors.secondary,
      OrderStatusFilter.shipped => AppColors.primary,
      OrderStatusFilter.delivered => AppColors.success,
      OrderStatusFilter.cancelled => AppColors.error,
    };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.xs + 2,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.12)
              : AppColors.scaffoldBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          border: Border.all(
            color: isSelected ? accentColor : AppColors.border,
            width: isSelected ? 1.4 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              filter.label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? accentColor : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            const SizedBox(width: AppSizes.xs + 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected
                    ? accentColor
                    : AppColors.textSecondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              child: Text(
                count.toString(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getCountForStatus(AdminOrdersState state, OrderStatusFilter filter) {
    switch (filter) {
      case OrderStatusFilter.all:
        return state.totalOrdersCount;
      case OrderStatusFilter.pending:
        return state.pendingCount;
      case OrderStatusFilter.processing:
        return state.processingCount;
      case OrderStatusFilter.shipped:
        return state.shippedCount;
      case OrderStatusFilter.delivered:
        return state.deliveredCount;
      case OrderStatusFilter.cancelled:
        return state.cancelledCount;
    }
  }
}
