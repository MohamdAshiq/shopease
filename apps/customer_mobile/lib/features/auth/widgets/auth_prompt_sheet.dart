import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../../app/routing/route_constants.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';
import 'auth_or_divider.dart';
import 'google_sign_in_button.dart';

// Modal Bottom Sheet prompting guests to authenticate
class AuthPromptSheet extends StatelessWidget {
  const AuthPromptSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.redirectPath,
    this.icon = IconsaxPlusBold.bag_2,
    this.onAuthenticated,
  });

  final String title;
  final String subtitle;
  final String redirectPath;
  final IconData icon;
  final VoidCallback? onAuthenticated;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String redirectPath,
    IconData icon = IconsaxPlusBold.bag_2,
    VoidCallback? onAuthenticated,
  }) async {
    HapticFeedback.lightImpact();
    final result = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AuthPromptSheet(
        title: title,
        subtitle: subtitle,
        redirectPath: redirectPath,
        icon: icon,
      ),
    );

    if (result == true) {
      // Allow modal bottom sheet reverse transition (250-300ms) to finish completely
      // and unmount from the root navigator before triggering destination route!
      await Future.delayed(const Duration(milliseconds: 300));
      if (context.mounted) {
        onAuthenticated?.call();
      }
      return true;
    }

    if (result == 'login') {
      if (context.mounted) {
        context.pushNamed(
          RouteNames.login,
          queryParameters: {'redirect': redirectPath},
        );
      }
      return false;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.isAuthenticated) {
          Navigator.of(context, rootNavigator: true).pop(true);
        } else if (state.hasError && state.errorMessage != null) {
          AppSnackBar.showAuthFeedback(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.screenPadding,
            AppSizes.sm + 4,
            AppSizes.screenPadding,
            AppSizes.xl,
          ),
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSizes.radiusXl),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top handle
                Container(
                  width: 36,
                  height: AppSizes.xs,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(AppSizes.xs / 2),
                  ),
                ),
                const SizedBox(height: AppSizes.lg),

                // Icon circle
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, color: AppColors.primary, size: 36),
                ),
                const SizedBox(height: AppSizes.md),

                // Title
                Text(
                  title,
                  style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.sm),

                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                  child: Text(
                    subtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppSizes.xl),

                // Continue with Google Button
                const GoogleSignInButton(),
                const SizedBox(height: AppSizes.md),

                // OR Divider
                const AuthOrDivider(),
                const SizedBox(height: AppSizes.md),

                // Sign In with Email
                AppButton(
                  label: 'Sign In with Email',
                  isFullWidth: true,
                  height: AppSizes.inputHeight,
                  borderRadius: AppSizes.radiusMd,
                  onPressed: state.isLoading
                      ? null
                      : () {
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pop('login');
                        },
                ),
                const SizedBox(height: AppSizes.sm),

                // Maybe Later
                TextButton(
                  onPressed: state.isLoading
                      ? null
                      : () => Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pop(false),
                  child: Text(
                    'Maybe Later',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
