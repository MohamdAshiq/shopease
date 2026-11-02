import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Empty state for customers data table
class CustomerTableEmptyState extends StatelessWidget {
  const CustomerTableEmptyState({
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
                    ? IconsaxPlusLinear.profile_2user
                    : IconsaxPlusLinear.search_status,
                size: AppSizes.iconLg,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              isStoreEmpty
                  ? 'No customers registered yet'
                  : 'No customers match your filters',
              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              isStoreEmpty
                  ? 'When buyers create accounts or place orders, their profiles will appear here.'
                  : 'Try adjusting your search keywords, segment chips, or sorting order.',
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
