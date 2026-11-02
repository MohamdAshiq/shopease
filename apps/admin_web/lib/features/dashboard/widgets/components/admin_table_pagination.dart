import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../constants/dashboard_constants.dart';

// Pagination footer for admin data tables
class AdminTablePagination extends StatelessWidget {
  const AdminTablePagination({
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Previous page button
        _buildNavButton(
          icon: IconsaxPlusLinear.arrow_left_1,
          tooltip: 'Previous Page',
          enabled: currentPage > 1,
          onPressed: () => onPageChanged(currentPage - 1),
        ),

        const SizedBox(width: AppSizes.sm),

        // Page numbers
        ..._buildPageNumbers(),

        const SizedBox(width: AppSizes.sm),

        // Next page button
        _buildNavButton(
          icon: IconsaxPlusLinear.arrow_right_3,
          tooltip: 'Next Page',
          enabled: currentPage < totalPages,
          onPressed: () => onPageChanged(currentPage + 1),
        ),
      ],
    );
  }

  List<Widget> _buildPageNumbers() {
    final pages = <Widget>[];

    for (int i = 1; i <= totalPages; i++) {
      if (totalPages > 6 &&
          i > 2 &&
          i < totalPages - 1 &&
          (i < currentPage - 1 || i > currentPage + 1)) {
        if (pages.isEmpty || pages.last is! Text) {
          pages.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.xs),
              child: Text(
                '…',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          );
        }
        continue;
      }

      final isSelected = i == currentPage;
      final pageIndex = i;

      pages.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: InkWell(
            onTap: () => onPageChanged(pageIndex),
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
                  width: 1.0,
                ),
              ),
              child: Text(
                pageIndex.toString(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return pages;
  }

  Widget _buildNavButton({
    required IconData icon,
    required String tooltip,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: DashboardConstants.pagerButtonSize,
      height: DashboardConstants.pagerButtonSize,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: IconButton(
        icon: Icon(icon, size: AppSizes.iconSm - 2),
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        color: enabled
            ? AppColors.textPrimary
            : AppColors.textSecondary.withValues(alpha: 0.4),
        onPressed: enabled ? onPressed : null,
      ),
    );
  }
}
