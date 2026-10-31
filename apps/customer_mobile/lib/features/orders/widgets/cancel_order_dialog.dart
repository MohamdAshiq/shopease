import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

// Cancel Order Dialog
class CancelOrderDialog extends StatelessWidget {
  const CancelOrderDialog({super.key, required this.onConfirmCancel});

  final VoidCallback onConfirmCancel;

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onConfirmCancel,
  }) {
    HapticFeedback.lightImpact();
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => CancelOrderDialog(
        onConfirmCancel: () {
          HapticFeedback.mediumImpact();
          Navigator.of(dialogContext).pop();
          onConfirmCancel();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      title: Text(
        'Cancel Order?',
        style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
      ),
      content: Text(
        'Are you sure you want to cancel this order? This action cannot be reversed.',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
          },
          child: Text(
            'Keep Order',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: onConfirmCancel,
          child: Text(
            'Cancel Order',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
