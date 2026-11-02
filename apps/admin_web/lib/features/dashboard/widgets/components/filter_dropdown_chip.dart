import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Dropdown Chip for Admin Filter Toolbars
class FilterDropdownChip<T> extends StatelessWidget {
  const FilterDropdownChip({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isActive = false,
  });

  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.buttonHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.border,
          width: isActive ? 1.5 : 1.0,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          focusColor: Colors.transparent,
          dropdownColor: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          icon: Icon(
            IconsaxPlusLinear.arrow_down,
            size: AppSizes.iconSm - 2,
            color: isActive ? AppColors.primary : AppColors.textSecondary,
          ),
          style: AppTextStyles.bodyMedium.copyWith(
            color: isActive ? AppColors.primary : AppColors.textPrimary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
