import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../dashboard/constants/dashboard_constants.dart';

// Minimal footer displaying platform version and system health status
class SystemStatusFooter extends StatelessWidget {
  const SystemStatusFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile =
            constraints.maxWidth < DashboardConstants.mobileBreakpoint;

        final platformInfo = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              IconsaxPlusLinear.code,
              size: AppSizes.iconSm - 2,
              color: AppColors.textHint,
            ),
            const SizedBox(width: AppSizes.xs),
            Text(
              'ShopEase Admin Portal v1.0.0',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textHint,
              ),
            ),
          ],
        );

        final systemStatus = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: DashboardConstants.statusIndicatorDotSize + 2,
              height: DashboardConstants.statusIndicatorDotSize + 2,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withValues(alpha: 0.4),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.xs),
            Text(
              'All Systems Operational',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );

        if (isMobile) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
            child: Column(
              children: [
                systemStatus,
                const SizedBox(height: AppSizes.xs),
                platformInfo,
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [platformInfo, systemStatus],
          ),
        );
      },
    );
  }
}
