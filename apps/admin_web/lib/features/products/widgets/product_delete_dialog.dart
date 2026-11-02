import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../dashboard/constants/dashboard_constants.dart';
import '../cubits/admin_products_cubit.dart';

// Confirmation dialog for deleting a product
class ProductDeleteDialog extends StatelessWidget {
  const ProductDeleteDialog({
    super.key,
    required this.product,
    required this.cubit,
  });

  final ProductModel product;
  final AdminProductsCubit cubit;

  static Future<void> show(
    BuildContext context, {
    required ProductModel product,
  }) {
    final cubit = context.read<AdminProductsCubit>();
    return showDialog<void>(
      context: context,
      builder: (_) => ProductDeleteDialog(product: product, cubit: cubit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.lg,
      ),
      child: Container(
        width: DashboardConstants.deleteDialogWidth,
        padding: const EdgeInsets.all(AppSizes.xl - 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.1),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.sm - 1),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: const Icon(
                    IconsaxPlusLinear.trash,
                    color: AppColors.error,
                    size: 18,
                  ),
                ),
                const SizedBox(width: AppSizes.md - 4),
                Text(
                  'Delete Product',
                  style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg - 4),

            // Product Item Preview Card
            Container(
              padding: const EdgeInsets.all(AppSizes.md - 4),
              decoration: BoxDecoration(
                color: AppColors.scaffoldBackground,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      border: Border.all(color: AppColors.border),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: AppNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      iconSize: AppSizes.iconSm,
                    ),
                  ),
                  const SizedBox(width: AppSizes.md - 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '#${product.id} • ${product.price.inr}',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.md),
            // Disclaimer text
            Text(
              'This action cannot be undone and will permanently remove this item from the store catalog.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSizes.xl - 4),
            // Actions Row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Cancel Button
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: AppSizes.sm + 2,
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),

                // Delete Button
                AppButton.compact(
                  label: 'Delete Product',
                  isDestructive: true,
                  height: 38,
                  borderRadius: AppSizes.radiusSm,
                  onPressed: () {
                    cubit.deleteProduct(product.id);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Removed "${product.title}" from catalog',
                        ),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
