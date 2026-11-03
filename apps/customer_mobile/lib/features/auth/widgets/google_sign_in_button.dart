import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

// Google Sign-In Button
class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
    this.onSuccess,
    this.label = 'Continue with Google',
  });

  final VoidCallback? onSuccess;
  final String label;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
      builder: (context, state) {
        return AppButton(
          label: label,
          isFullWidth: true,
          isOutlined: true,
          height: AppSizes.inputHeight,
          borderRadius: AppSizes.radiusMd,
          borderColor: AppColors.border,
          textColor: AppColors.textPrimary,
          isLoading: state.isGoogleLoading,
          customIcon: Image.asset(
            AppAssets.googleIcon,
            package: AppAssets.package,
            width: AppSizes.iconMd,
            height: AppSizes.iconMd,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              IconsaxPlusBold.global,
              size: AppSizes.iconMd,
              color: AppColors.primary,
            ),
          ),
          onPressed: state.isLoading
              ? null
              : () async {
                  HapticFeedback.lightImpact();
                  final success = await context
                      .read<AuthCubit>()
                      .signInWithGoogle();
                  if (success) {
                    onSuccess?.call();
                  }
                },
        );
      },
    );
  }
}
