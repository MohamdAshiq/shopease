import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

// Support and Help Dialog
class HelpSupportDialog extends StatelessWidget {
  const HelpSupportDialog({super.key});

  static Future<void> show(BuildContext context) {
    HapticFeedback.lightImpact();
    return showDialog<void>(
      context: context,
      builder: (context) => const HelpSupportDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg + 4,
        vertical: AppSizes.lg,
      ),
      titlePadding: const EdgeInsets.fromLTRB(
        AppSizes.md + AppSizes.xs,
        AppSizes.md + AppSizes.xs,
        AppSizes.md + AppSizes.xs,
        0,
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        AppSizes.md + AppSizes.xs,
        AppSizes.radiusMd,
        AppSizes.md + AppSizes.xs,
        AppSizes.sm,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(
        AppSizes.md + AppSizes.xs,
        AppSizes.xs,
        AppSizes.md + AppSizes.xs,
        AppSizes.sm,
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: const Icon(
              IconsaxPlusLinear.message_question,
              color: AppColors.primary,
              size: AppSizes.iconSm + AppSizes.xs,
            ),
          ),
          const SizedBox(width: AppSizes.sm + 2),
          Text(
            'Help & Support',
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'We’re here to help with your orders or account.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppSizes.md),

              // Help Card
              _buildContactCard(
                icon: IconsaxPlusLinear.call,
                label: 'Customer Helpline',
                value: '+91 1800 200 7467',
              ),
              const SizedBox(height: AppSizes.sm + 2),

              // Email Card
              _buildContactCard(
                icon: IconsaxPlusLinear.sms,
                label: 'Support Email',
                value: 'support@shopease.com',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.xs + 2,
            ),
          ),
          child: Text(
            'Close',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildContactCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.radiusMd,
        vertical: AppSizes.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.7)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: AppSizes.iconSm, color: AppColors.primary),
          ),
          const SizedBox(width: AppSizes.radiusMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSizes.xs / 2),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
