import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Logout Button with Confirmation Dialog
class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key, required this.onConfirm});

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        IconsaxPlusLinear.logout,
        color: Colors.white54,
        size: 18,
      ),
      tooltip: 'Logout',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: () => _showLogoutDialog(context),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          titlePadding: const EdgeInsets.only(
            top: AppSizes.lg,
            left: AppSizes.md,
            right: AppSizes.md,
          ),
          contentPadding: const EdgeInsets.all(AppSizes.md),
          actionsPadding: const EdgeInsets.all(AppSizes.md),
          title: Text(
            'Confirm Logout',
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Are you sure you want to log out of the admin panel?',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: AppSizes.sm + 4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
              ),
              child: Text(
                'Cancel',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.lg,
                  vertical: AppSizes.sm + 4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
              ),
              child: Text(
                'Logout',
                style: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
