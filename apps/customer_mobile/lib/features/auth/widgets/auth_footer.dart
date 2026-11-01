import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import 'auth_or_divider.dart';
import 'google_sign_in_button.dart';

// Footer for Auth views
class AuthFooter extends StatelessWidget {
  const AuthFooter({
    super.key,
    required this.onGoogleAuthSuccess,
    required this.promptText,
    required this.actionText,
    required this.onActionTap,
  });

  final VoidCallback onGoogleAuthSuccess;
  final String promptText;
  final String actionText;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // OR Divider
        const AuthOrDivider(),
        const SizedBox(height: AppSizes.lg),

        // Google Sign-In Button
        GoogleSignInButton(onSuccess: onGoogleAuthSuccess),
        const SizedBox(height: AppSizes.xl),

        // Prompt & Action Switch Link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              promptText,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                HapticFeedback.lightImpact();
                onActionTap();
              },
              child: Text(
                actionText,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.lg),
      ],
    );
  }
}
