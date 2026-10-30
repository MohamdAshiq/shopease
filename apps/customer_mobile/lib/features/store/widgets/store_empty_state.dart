import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../widgets/app_button.dart';

// Empty state view
class StoreEmptyState extends StatelessWidget {
  const StoreEmptyState({
    super.key,
    required this.query,
    required this.onReset,
  });

  final String query;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                IconsaxPlusLinear.box_search,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              'No Products Found',
              style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSizes.xs + 2),
            Text(
              query.isNotEmpty
                  ? 'No results match "$query". Try adjusting your search or filters.'
                  : 'No products match the selected category filter.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.lg),

            // Reset Button
            AppButton.compact(
              onPressed: onReset,
              icon: Icons.refresh_rounded,
              label: 'Reset All Filters',
            ),
          ],
        ),
      ),
    );
  }
}
