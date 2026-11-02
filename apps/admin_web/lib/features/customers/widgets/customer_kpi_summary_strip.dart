import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../dashboard/constants/dashboard_constants.dart';
import '../../dashboard/widgets/overview/stat_card.dart';
import '../cubits/admin_customers_cubit.dart';
import '../cubits/admin_customers_state.dart';

// KPI Summary Strip for Customer Management
class CustomerKpiSummaryStrip extends StatelessWidget {
  const CustomerKpiSummaryStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCustomersCubit, AdminCustomersState>(
      buildWhen: (prev, curr) => prev.customers != curr.customers,
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 650;
            final int crossAxisCount = constraints.maxWidth < 1100 ? 2 : 4;
            final double spacing = isMobile ? AppSizes.md : AppSizes.lg;

            final total = state.totalCustomersCount;
            final active = state.activeBuyersCount;
            final conversionRate = total == 0
                ? 0
                : ((active / total) * 100).toInt();

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
                // Total Customers
                StatCard(
                  title: 'TOTAL CUSTOMERS',
                  value: total.toString(),
                  badgeText: 'All Accounts',
                  badgeColor: AppColors.primary,
                  icon: IconsaxPlusBold.profile_2user,
                  iconColor: AppColors.primary,
                ),
                // Active Buyers
                StatCard(
                  title: 'ACTIVE BUYERS',
                  value: active.toString(),
                  badgeText: '$conversionRate% Placed Orders',
                  badgeColor: AppColors.success,
                  icon: IconsaxPlusBold.shopping_cart,
                  iconColor: AppColors.success,
                ),
                // Average Lifetime Value
                StatCard(
                  title: 'AVG. LIFETIME VALUE',
                  value: state.averageLtv.inr2,
                  badgeText: 'Per Active Buyer',
                  badgeColor: AppColors.secondary,
                  icon: IconsaxPlusBold.wallet_money,
                  iconColor: AppColors.secondary,
                ),
                // VIP Segment
                StatCard(
                  title: 'VIP CLIENTS',
                  value: state.vipCount.toString(),
                  badgeText: 'High Spend',
                  badgeColor: AppColors.warning,
                  icon: IconsaxPlusBold.crown,
                  iconColor: AppColors.warning,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
