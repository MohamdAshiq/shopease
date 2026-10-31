import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

// Confirmation Dialog for deleting an address
class DeleteAddressDialog extends StatelessWidget {
  const DeleteAddressDialog({super.key, required this.onConfirmDelete});

  final VoidCallback onConfirmDelete;

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onConfirmDelete,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => DeleteAddressDialog(
        onConfirmDelete: () {
          HapticFeedback.mediumImpact();
          Navigator.of(dialogContext).pop();
          onConfirmDelete();
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
        'Delete Address',
        style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
      ),
      content: Text(
        'Are you sure you want to remove this delivery address? This action cannot be undone.',
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
            'Cancel',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: onConfirmDelete,
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: Text(
            'Delete',
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
