import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../dashboard/constants/dashboard_constants.dart';

// Pagination footer for admin data tables
class ProductsTablePagination extends StatelessWidget {
  const ProductsTablePagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.onPageChanged,
  });

  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final startItem = (currentPage - 1) * itemsPerPage + 1;
    final endItem = (currentPage * itemsPerPage).clamp(0, totalItems);

    return LayoutBuilder(
      builder: (context, footerConstraints) {
        final isMobile = footerConstraints.maxWidth < 600;
        final horizontalPadding = isMobile ? AppSizes.md : AppSizes.xl;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: AppSizes.md,
          ),
          child: isMobile
              ? Column(
                  children: [
                    Text(
                      'Showing $startItem–$endItem of $totalItems items',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    _buildPaginationControls(),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Showing $startItem–$endItem of $totalItems items',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    _buildPaginationControls(),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildPaginationControls() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(IconsaxPlusLinear.arrow_left_1),
            iconSize: AppSizes.iconSm,
            visualDensity: VisualDensity.compact,
            splashRadius: 18,
            color: currentPage > 1 ? AppColors.textPrimary : AppColors.textHint,
            onPressed: currentPage > 1
                ? () => onPageChanged(currentPage - 1)
                : null,
          ),
          const SizedBox(width: AppSizes.xs),

          // Page Number Buttons
          ...List.generate(totalPages, (index) {
            final pageNum = index + 1;
            final isSelected = pageNum == currentPage;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: InkWell(
                onTap: () => onPageChanged(pageNum),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                child: Container(
                  width: DashboardConstants.pagerButtonSize,
                  height: DashboardConstants.pagerButtonSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Text(
                    pageNum.toString(),
                    style: TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? AppColors.textOnPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }),

          const SizedBox(width: AppSizes.xs),
          IconButton(
            icon: const Icon(IconsaxPlusLinear.arrow_right_3),
            iconSize: AppSizes.iconSm,
            visualDensity: VisualDensity.compact,
            splashRadius: 18,
            color: currentPage < totalPages
                ? AppColors.textPrimary
                : AppColors.textHint,
            onPressed: currentPage < totalPages
                ? () => onPageChanged(currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }
}
