import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Empty state for orders table
class OrdersTableEmptyState extends StatelessWidget {
  const OrdersTableEmptyState({
    super.key,
    required this.isStoreEmpty,
    required this.onResetFilters,
  });

  final bool isStoreEmpty;
  final VoidCallback onResetFilters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.xl,
        vertical: AppSizes.xxl,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: AppColors.scaffoldBackground,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border, width: 1.0),
              ),
              child: Icon(
                isStoreEmpty
                    ? IconsaxPlusLinear.shopping_bag
                    : IconsaxPlusLinear.search_status,
                size: AppSizes.iconLg,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              isStoreEmpty
                  ? 'No orders placed yet'
                  : 'No orders match your filters',
              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              isStoreEmpty
                  ? 'When customers place orders from your store, they will appear here.'
                  : 'Try adjusting your search query, status chips, or payment filters.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (!isStoreEmpty) ...[
              const SizedBox(height: AppSizes.lg),
              AppButton.compact(
                label: 'Reset Filters',
                icon: IconsaxPlusLinear.rotate_left,
                isOutlined: true,
                onPressed: onResetFilters,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
