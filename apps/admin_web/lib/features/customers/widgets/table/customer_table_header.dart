import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Table Header for Customers data table
class CustomerTableHeader extends StatelessWidget {
  const CustomerTableHeader({
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
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final horizontalPadding = isMobile ? AppSizes.md : AppSizes.xl;

        final countInfo = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Customers Directory',
              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: AppSizes.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.sm,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              child: Text(
                '$totalCount ${totalCount == 1 ? 'customer' : 'customers'}',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: AppSizes.md,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: countInfo,
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

  Widget _buildResetButton() {
    return AppButton.compact(
      label: 'Reset Filters ($activeFilterCount)',
      icon: IconsaxPlusLinear.rotate_left,
      isOutlined: true,
      onPressed: onResetFilters,
    );
  }
}
