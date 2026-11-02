import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../dashboard/constants/dashboard_constants.dart';
import '../../dashboard/widgets/overview/stat_card.dart';
import '../cubits/admin_products_cubit.dart';
import '../cubits/admin_products_state.dart';

// KPI Summary Strip for Products Catalog
class ProductKpiSummaryStrip extends StatelessWidget {
  const ProductKpiSummaryStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminProductsCubit, AdminProductsState>(
      buildWhen: (previous, current) => previous.products != current.products,
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
                // Total Products
                StatCard(
                  title: 'TOTAL PRODUCTS',
                  value: state.products.length.toString(),
                  badgeText: 'All Items',
                  badgeColor: AppColors.primary,
                  icon: IconsaxPlusBold.box,
                  iconColor: AppColors.primary,
                ),
                // In Stock Products
                StatCard(
                  title: 'IN STOCK',
                  value: state.inStockCount.toString(),
                  badgeText: '>= 15 Units',
                  badgeColor: AppColors.success,
                  icon: IconsaxPlusBold.tick_circle,
                  iconColor: AppColors.success,
                ),
                // Low Stock Products
                StatCard(
                  title: 'LOW STOCK',
                  value: state.lowStockCount.toString(),
                  badgeText: '< 15 Units',
                  badgeColor: AppColors.warning,
                  icon: IconsaxPlusBold.warning_2,
                  iconColor: AppColors.warning,
                ),
                // Out of Stock Products
                StatCard(
                  title: 'OUT OF STOCK',
                  value: state.outOfStockCount.toString(),
                  badgeText: 'Unavailable',
                  badgeColor: AppColors.error,
                  icon: IconsaxPlusBold.close_circle,
                  iconColor: AppColors.error,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
