import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../auth/cubits/auth_cubit.dart';
import '../cubits/profile_cubit.dart';

// Sign Out Confirmation Dialog
class SignOutDialog extends StatelessWidget {
  const SignOutDialog({super.key});

  static Future<void> show(BuildContext context) {
    HapticFeedback.lightImpact();
    return showDialog<void>(
      context: context,
      builder: (context) => const SignOutDialog(),
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
        'Sign Out?',
        style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
      ),
      content: Text(
        'Are you sure you want to sign out from your ShopEase account?',
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
            'Stay Signed In',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.of(context).pop();
            context.read<AuthCubit>().signOut();
            context.read<ProfileCubit>().setUser(null);
            AppSnackBar.showSuccess(context, 'Signed out successfully');
          },
          child: Text(
            'Sign Out',
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
