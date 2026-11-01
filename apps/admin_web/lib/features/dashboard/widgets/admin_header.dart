import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import 'components/current_date_chip.dart';

// Top Header bar for the admin dashboard
class AdminHeader extends StatelessWidget {
  const AdminHeader({
    super.key,
    required this.title,
    this.showMenuButton = false,
    this.onMenuPressed,
    this.onNotificationPressed,
  });

  final String title;
  final bool showMenuButton;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onNotificationPressed;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: [
          // Mobile Menu Toggle Button
          if (showMenuButton) ...[
            IconButton(
              icon: const Icon(Icons.menu),
              color: AppColors.textPrimary,
              onPressed: onMenuPressed,
              tooltip: 'Open navigation',
            ),
            const SizedBox(width: AppSizes.xs),
          ],

          // Current Screen Title
          Text(
            title,
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const Spacer(),

          // Current Date Chip
          if (!isMobile) ...[
            const CurrentDateChip(),
            const SizedBox(width: AppSizes.sm),
          ],

          // Notification Bell with Unread Badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  IconsaxPlusLinear.notification,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                tooltip: 'Notifications',
                onPressed: onNotificationPressed ?? () {},
              ),
              Positioned(
                right: AppSizes.sm + 2,
                top: AppSizes.sm + 2,
                child: Container(
                  width: AppSizes.sm,
                  height: AppSizes.sm,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
