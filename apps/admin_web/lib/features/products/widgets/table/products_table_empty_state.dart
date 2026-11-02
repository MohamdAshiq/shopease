import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Empty state for products table
class ProductsTableEmptyState extends StatelessWidget {
  const ProductsTableEmptyState({
    super.key,
    required this.isCatalogEmpty,
    required this.onAddProduct,
    required this.onResetFilters,
  });

  final bool isCatalogEmpty;
  final VoidCallback onAddProduct;
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
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: const BoxDecoration(
                color: AppColors.scaffoldBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCatalogEmpty
                    ? IconsaxPlusLinear.box_add
                    : IconsaxPlusLinear.box_remove,
                size: AppSizes.iconXl,
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              isCatalogEmpty ? 'Your catalog is empty' : 'No products found',
              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              isCatalogEmpty
                  ? 'Get started by adding your first product to the inventory catalog.'
                  : 'Try adjusting your search query, stock status, or category filter.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            if (isCatalogEmpty)
              AppButton.compact(
                label: 'Add First Product',
                icon: IconsaxPlusLinear.add,
                onPressed: onAddProduct,
              )
            else
              AppButton.compact(
                label: 'Reset Filters',
                icon: IconsaxPlusLinear.refresh,
                isOutlined: true,
                onPressed: onResetFilters,
              ),
          ],
        ),
      ),
    );
  }
}
