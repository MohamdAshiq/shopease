import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../constants/dashboard_constants.dart';
import '../../cubits/dashboard_overview_cubit.dart';
import '../../cubits/dashboard_overview_state.dart';
import 'stat_card.dart';

// Responsive grid of KPI Cards
class StatCardsGrid extends StatelessWidget {
  const StatCardsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardOverviewCubit, DashboardOverviewState>(
      buildWhen: (previous, current) =>
          previous.kpiMetrics != current.kpiMetrics,
      builder: (context, state) {
        final metrics = state.kpiMetrics;

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
                // Revenue Card
                StatCard(
                  title: 'TOTAL REVENUE',
                  value: metrics.totalRevenue.inr,
                  badgeText: '+14.2% MoM',
                  badgeColor: AppColors.success,
                  icon: IconsaxPlusBold.money_recive,
                  iconColor: AppColors.success,
                ),

                // Orders Card
                StatCard(
                  title: 'TOTAL ORDERS',
                  value: metrics.totalOrdersCount.toString(),
                  badgeText: '${metrics.pendingOrdersCount} Pending',
                  badgeColor: AppColors.warning,
                  icon: IconsaxPlusBold.receipt_item,
                  iconColor: AppColors.primary,
                ),

                // Products Card
                StatCard(
                  title: 'ACTIVE PRODUCTS',
                  value: metrics.activeProductsCount.toString(),
                  badgeText: '${metrics.categoryCount} Categories',
                  badgeColor: AppColors.info,
                  icon: IconsaxPlusBold.box,
                  iconColor: AppColors.info,
                ),

                // Low Stock Card
                StatCard(
                  title: 'LOW STOCK ALERTS',
                  value: metrics.lowStockCount.toString(),
                  unit: 'Items',
                  badgeText: 'Needs Restock',
                  badgeColor: AppColors.secondary,
                  icon: IconsaxPlusBold.danger,
                  iconColor: AppColors.secondary,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
