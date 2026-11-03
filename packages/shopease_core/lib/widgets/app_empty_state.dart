import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

// App Empty State
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = IconsaxPlusLinear.box_search,
    this.iconColor,
    this.iconBackgroundColor,
    this.action,
    this.isCompact = false,
  });

  // Error State
  factory AppEmptyState.error({
    Key? key,
    String title = 'Something went wrong',
    required String message,
    VoidCallback? onRetry,
    bool isCompact = false,
  }) {
    return AppEmptyState(
      key: key,
      title: title,
      message: message,
      icon: IconsaxPlusLinear.warning_2,
      iconColor: AppColors.error,
      iconBackgroundColor: AppColors.error.withValues(alpha: 0.08),
      isCompact: isCompact,
      action: onRetry != null
          ? AppButton.compact(
              onPressed: onRetry,
              icon: Icons.refresh_rounded,
              label: 'Try Again',
            )
          : null,
    );
  }

  final String title;
  final String message;
  final IconData icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final Widget? action;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppColors.primary;
    final effectiveIconBg =
        iconBackgroundColor ?? effectiveIconColor.withValues(alpha: 0.08);

    if (isCompact) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.xl,
          horizontal: AppSizes.lg,
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.border, width: 0.8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: effectiveIconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 38, color: effectiveIconColor),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: AppSizes.md),
              action!,
            ],
          ],
        ),
      );
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: effectiveIconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: effectiveIconColor),
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSizes.xs + 2),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: AppSizes.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
