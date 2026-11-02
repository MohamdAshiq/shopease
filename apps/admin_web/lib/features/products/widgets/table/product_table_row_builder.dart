import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../dashboard/constants/dashboard_constants.dart';
import '../../cubits/admin_products_cubit.dart';
import '../product_delete_dialog.dart';
import '../product_form_dialog.dart';
import 'product_stock_badge.dart';

// Helper class for products table header and data rows
abstract final class ProductTableRowBuilder {
  static TableRow buildHeader() {
    return TableRow(
      decoration: const BoxDecoration(
        color: AppColors.scaffoldBackground,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1.0),
        ),
      ),
      children: [
        _buildHeaderCell('PRODUCT'),
        _buildHeaderCell('CATEGORY'),
        _buildHeaderCell('PRICE'),
        _buildHeaderCell('STOCK LEVEL'),
        _buildHeaderCell('ACTIVE'),
        _buildHeaderCell('ACTIONS', alignment: Alignment.centerRight),
      ],
    );
  }

  static Widget _buildHeaderCell(
    String title, {
    Alignment alignment = Alignment.centerLeft,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm + 2,
        vertical: AppSizes.md - 2,
      ),
      child: Align(
        alignment: alignment,
        child: Text(
          title,
          style: AppTextStyles.labelSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
            letterSpacing: 0.8,
            fontSize: 10.0,
          ),
        ),
      ),
    );
  }

  static TableRow buildRow({
    required BuildContext context,
    required ProductModel product,
    required AdminProductsCubit cubit,
    required bool isEven,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: isEven
            ? AppColors.surface
            : AppColors.scaffoldBackground.withValues(alpha: 0.35),
        border: const Border(
          bottom: BorderSide(color: AppColors.divider, width: 1.0),
        ),
      ),
      children: [
        // Product (Thumbnail + Name + SKU)
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.sm + 2,
            vertical: AppSizes.md - 2,
          ),
          child: Row(
            children: [
              Container(
                width: DashboardConstants.productThumbnailSize,
                height: DashboardConstants.productThumbnailSize,
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  border: Border.all(color: AppColors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: AppNetworkImage(
                  imageUrl: product.primaryImageUrl,
                  fit: BoxFit.cover,
                  iconSize: AppSizes.iconSm,
                ),
              ),
              const SizedBox(width: AppSizes.sm + 2),
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
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '#${product.id}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Category Badge
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.sm + 2,
            vertical: AppSizes.md - 2,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.sm,
                vertical: AppSizes.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Text(
                product.category,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),

        // Price
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.sm + 2,
            vertical: AppSizes.md - 2,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              product.price.inr,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),

        // Stock Level Pill
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.sm + 2,
            vertical: AppSizes.md - 2,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: ProductStockBadge(
              stock: product.stock,
              isAvailable: product.isAvailable,
            ),
          ),
        ),

        // Availability Switch
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.sm + 2,
            vertical: AppSizes.md - 2,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Transform.scale(
              scale: 0.8,
              alignment: Alignment.centerLeft,
              child: Switch.adaptive(
                value: product.isAvailable,
                activeTrackColor: AppColors.primary,
                onChanged: (_) => cubit.toggleAvailability(product.id),
              ),
            ),
          ),
        ),

        // Actions
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.sm + 2,
            vertical: AppSizes.md - 2,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(AppSizes.xs),
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    IconsaxPlusLinear.edit_2,
                    size: AppSizes.iconSm + 2,
                    color: AppColors.primary,
                  ),
                  tooltip: 'Edit Product',
                  splashRadius: 18,
                  onPressed: () =>
                      ProductFormDialog.show(context, initialProduct: product),
                ),
                const SizedBox(width: AppSizes.xs),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(AppSizes.xs),
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    IconsaxPlusLinear.trash,
                    size: AppSizes.iconSm + 2,
                    color: AppColors.error,
                  ),
                  tooltip: 'Delete Product',
                  splashRadius: 18,
                  onPressed: () =>
                      ProductDeleteDialog.show(context, product: product),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
