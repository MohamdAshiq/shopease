import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../dashboard/constants/dashboard_constants.dart';
import '../../dashboard/widgets/overview/stat_card.dart';
import '../cubits/admin_orders_cubit.dart';
import '../cubits/admin_orders_state.dart';

// KPI Summary Strip for Orders Management
class OrderKpiSummaryStrip extends StatelessWidget {
  const OrderKpiSummaryStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminOrdersCubit, AdminOrdersState>(
      buildWhen: (prev, curr) =>
          prev.orders != curr.orders || prev.statusFilter != curr.statusFilter,
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 650;
            final int crossAxisCount = constraints.maxWidth < 1100 ? 2 : 4;
            final double spacing = isMobile ? AppSizes.md : AppSizes.lg;

            return GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                mainAxisExtent: DashboardConstants.statCardHeight,
              ),
              children: [
                // Total Orders
                StatCard(
                  title: 'TOTAL ORDERS',
                  value: state.totalOrdersCount.toString(),
                  badgeText: 'All Records',
                  badgeColor: AppColors.primary,
                  icon: IconsaxPlusBold.shopping_bag,
                  iconColor: AppColors.primary,
                ),
                // Pending Fulfillment
                StatCard(
                  title: 'PENDING ACTION',
                  value: state.pendingCount.toString(),
                  badgeText: state.pendingCount > 0
                      ? 'Needs Attention'
                      : 'All Clear',
                  badgeColor: AppColors.warning,
                  icon: IconsaxPlusBold.clock,
                  iconColor: AppColors.warning,
                ),
                // In Processing / Transit
                StatCard(
                  title: 'IN FULFILLMENT',
                  value: (state.processingCount + state.shippedCount)
                      .toString(),
                  badgeText:
                      '${state.processingCount} Proc · ${state.shippedCount} Ship',
                  badgeColor: AppColors.secondary,
                  icon: IconsaxPlusBold.truck_fast,
                  iconColor: AppColors.secondary,
                ),
                // Delivered Orders
                StatCard(
                  title: 'DELIVERED',
                  value: state.deliveredCount.toString(),
                  badgeText: 'Completed',
                  badgeColor: AppColors.success,
                  icon: IconsaxPlusBold.tick_circle,
                  iconColor: AppColors.success,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
