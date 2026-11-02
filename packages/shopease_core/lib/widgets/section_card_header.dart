import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Reusable header card
class SectionCardHeader extends StatelessWidget {
  const SectionCardHeader({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primary,
                    size: AppSizes.iconSm,
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Text(
                  title,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            ?trailing,
          ],
        ),
        if (showDivider)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.sm + 2),
            child: Divider(height: 1, color: AppColors.divider),
          ),
      ],
    );
  }
}
