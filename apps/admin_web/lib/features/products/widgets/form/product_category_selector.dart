import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Category dropdown selector with icons for product form
class ProductCategorySelector extends StatelessWidget {
  const ProductCategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  final String selectedCategory;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final availableCategories = AppCategories.items
        .where((item) => item.name != 'All')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSizes.xs + 2),
        Container(
          height: AppSizes.inputHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          decoration: BoxDecoration(
            color: AppColors.scaffoldBackground,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCategory,
              focusColor: Colors.transparent,
              dropdownColor: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              isExpanded: true,
              icon: const Icon(
                IconsaxPlusLinear.arrow_down,
                size: AppSizes.iconSm,
                color: AppColors.textSecondary,
              ),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              items: availableCategories.map((item) {
                final isSelected = selectedCategory == item.name;
                return DropdownMenuItem<String>(
                  value: item.name,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: AppSizes.iconSm - 2,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Text(item.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
