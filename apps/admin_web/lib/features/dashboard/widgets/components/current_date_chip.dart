import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Current Date Chip Widget
class CurrentDateChip extends StatelessWidget {
  const CurrentDateChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm + 4,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            IconsaxPlusLinear.calendar_1,
            size: 15,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            DateTime.now().formattedDateWithWeekday,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
