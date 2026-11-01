import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../widgets/app_button.dart';
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
          isLoading: state.isLoading,
          customIcon: Image.asset(
            AppAssets.googleIcon,
            package: AppAssets.package,
            width: 50,
            height: 50,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              IconsaxPlusBold.global,
              size: 24,
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
