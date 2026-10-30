import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../cubits/store_cubit.dart';

// Modal bottom sheet for sorting option
class StoreSortSheet extends StatelessWidget {
  const StoreSortSheet({
    super.key,
    required this.currentSort,
    required this.onSortSelected,
  });

  final StoreSortOption currentSort;
  final ValueChanged<StoreSortOption> onSortSelected;

  static Future<void> show(
    BuildContext context, {
    required StoreSortOption currentSort,
    required ValueChanged<StoreSortOption> onSortSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXl),
        ),
      ),
      builder: (context) => StoreSortSheet(
        currentSort: currentSort,
        onSortSelected: onSortSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenPadding,
          vertical: AppSizes.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),

            // Sheet Title
            Text('Sort Products By', style: AppTextStyles.h3),
            const SizedBox(height: AppSizes.md),

            // Options List
            ...StoreSortOption.values.map((option) {
              final isSelected = option == currentSort;
              return InkWell(
                onTap: () {
                  onSortSelected(option);
                  Navigator.of(context).pop();
                },
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSizes.sm + 4,
                    horizontal: AppSizes.xs,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        option.label,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                          size: 20,
                        )
                      else
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.border,
                              width: 1.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: AppSizes.sm),
          ],
        ),
      ),
    );
  }
}
