import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../../app/routing/admin_route_constants.dart';
import '../../constants/dashboard_constants.dart';
import '../../cubits/dashboard_overview_cubit.dart';
import '../../cubits/dashboard_overview_state.dart';
import '../components/dashboard_card.dart';

// List of low-stock items
class InventoryAlertsCard extends StatelessWidget {
  const InventoryAlertsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardOverviewCubit, DashboardOverviewState>(
      buildWhen: (prev, curr) => prev.inventoryAlerts != curr.inventoryAlerts,
      builder: (context, state) {
        final lowStockProducts = state.inventoryAlerts;

        return DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with count badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Inventory Alerts',
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: AppSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                    child: Text(
                      '${lowStockProducts.length} LOW STOCK',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.lg),

              // List of low-stock items
              if (lowStockProducts.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.xl),
                  child: Center(
                    child: Text(
                      'All items are adequately stocked',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                )
              else
                ...lowStockProducts.map((product) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSizes.md),
                    padding: const EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldBackground,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: Row(
                      children: [
                        // Product Thumbnail
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusSm,
                          ),
                          child: Container(
                            width: DashboardConstants.productThumbnailSize,
                            height: DashboardConstants.productThumbnailSize,
                            color: AppColors.divider,
                            child: product.imageUrl.isNotEmpty
                                ? Image.network(
                                    product.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              IconsaxPlusLinear.box,
                                              color: AppColors.textSecondary,
                                              size:
                                                  AppSizes.iconMd - AppSizes.xs,
                                            ),
                                  )
                                : const Icon(
                                    IconsaxPlusLinear.box,
                                    color: AppColors.textSecondary,
                                    size: AppSizes.iconMd - AppSizes.xs,
                                  ),
                          ),
                        ),
                        const SizedBox(width: AppSizes.md),

                        // Title & Category
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                product.title,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: AppSizes.xs),
                              Text(
                                product.category,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSizes.md),

                        // Stock Count Chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.sm + AppSizes.xs / 2,
                            vertical: AppSizes.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusFull,
                            ),
                          ),
                          child: Text(
                            '${product.stock} left',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

              const SizedBox(height: AppSizes.xs),

              // Manage Catalog Button
              Center(
                child: InkWell(
                  onTap: () => context.go(AdminRoutePaths.products),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: AppSizes.sm,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Manage Catalog',
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppSizes.xs),
                        const Icon(
                          IconsaxPlusLinear.arrow_right_3,
                          size: AppSizes.iconSm - AppSizes.xs,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
