import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Header bar for products table
class ProductsTableHeader extends StatelessWidget {
  const ProductsTableHeader({
    super.key,
    required this.totalCount,
    required this.hasFilters,
    required this.activeFilterCount,
    required this.onResetFilters,
  });

  final int totalCount;
  final bool hasFilters;
  final int activeFilterCount;
  final VoidCallback onResetFilters;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, headerConstraints) {
        final isMobile = headerConstraints.maxWidth < 600;
        final horizontalPadding = isMobile ? AppSizes.md : AppSizes.xl;
        final verticalPadding = isMobile ? AppSizes.md : AppSizes.lg;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: _buildTitle(),
                ),
              ),
              if (hasFilters) ...[
                const SizedBox(width: AppSizes.sm),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: _buildResetButton(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Inventory Catalog',
          style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: AppSizes.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.sm,
            vertical: AppSizes.xs - 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          ),
          child: Text(
            '$totalCount ${totalCount == 1 ? 'item' : 'items'}',
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResetButton() {
    return TextButton.icon(
      onPressed: onResetFilters,
      icon: const Icon(
        IconsaxPlusLinear.refresh,
        size: AppSizes.iconSm - 2,
        color: AppColors.primary,
      ),
      label: Text(
        'Reset Filters ($activeFilterCount)',
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
