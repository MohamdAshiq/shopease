import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../cubits/dashboard_overview_cubit.dart';
import '../widgets/overview/category_sales_breakdown_card.dart';
import '../widgets/overview/inventory_alerts_card.dart';
import '../widgets/overview/recent_orders_table.dart';
import '../widgets/overview/revenue_trend_chart_card.dart';
import '../widgets/overview/stat_cards_grid.dart';

// Dashboard overview screen
class AdminDashboardOverviewScreen extends StatelessWidget {
  const AdminDashboardOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardOverviewCubit()..loadDashboard(),
      child: const _DashboardOverviewContent(),
    );
  }
}

class _DashboardOverviewContent extends StatelessWidget {
  const _DashboardOverviewContent();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1200;
        final horizontalPadding = constraints.maxWidth < 650
            ? AppSizes.md
            : AppSizes.xl;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: AppSizes.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // KPI Stat Cards Grid
              const StatCardsGrid(),

              const SizedBox(height: AppSizes.xl),

              // Revenue Trend Chart & Category Breakdown
              if (isDesktop)
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: RevenueTrendChartCard()),
                    SizedBox(width: AppSizes.xl),
                    Expanded(flex: 1, child: CategorySalesBreakdownCard()),
                  ],
                )
              else
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RevenueTrendChartCard(),
                    SizedBox(height: AppSizes.xl),
                    CategorySalesBreakdownCard(),
                  ],
                ),

              const SizedBox(height: AppSizes.xl),

              // Recent Orders Table & Inventory Alerts
              if (isDesktop)
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: RecentOrdersTable()),
                    SizedBox(width: AppSizes.xl),
                    Expanded(flex: 1, child: InventoryAlertsCard()),
                  ],
                )
              else
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RecentOrdersTable(),
                    SizedBox(height: AppSizes.xl),
                    InventoryAlertsCard(),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
