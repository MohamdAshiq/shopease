import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Stat Card in Dashboard Overview
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.unit,
    required this.badgeText,
    required this.badgeColor,
    required this.icon,
    required this.iconColor,
  });

  static const double _borderWidth = 1.5;
  static const double _badgeFontSize = 9.0;
  static const double _titleFontSize = 10.0;
  static const double _metricFontSize = 24.0;
  static const double _iconSize = 18.0;

  final String title;
  final String value;
  final String? unit;
  final String badgeText;
  final Color badgeColor;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: iconColor.withValues(alpha: 0.24),
          width: _borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, AppSizes.xs),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header: Icon badge and Status Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.sm),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Icon(icon, color: iconColor, size: _iconSize),
              ),
              const SizedBox(width: AppSizes.xs),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.sm,
                    vertical: AppSizes.xs,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: Text(
                    badgeText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: badgeColor,
                      fontSize: _badgeFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content: Uppercase Title and Metric Value
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.2,
                  fontSize: _titleFontSize,
                ),
              ),
              const SizedBox(height: AppSizes.sm + 4),
              RichText(
                text: TextSpan(
                  text: value,
                  style: AppTextStyles.h2.copyWith(
                    fontSize: _metricFontSize,
                    height: 1.0,
                    color: AppColors.textPrimary,
                  ),
                  children: [
                    if (unit != null)
                      TextSpan(
                        text: ' $unit',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
