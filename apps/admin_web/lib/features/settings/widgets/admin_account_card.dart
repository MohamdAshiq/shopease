import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../dashboard/constants/dashboard_constants.dart';
import '../../dashboard/widgets/components/dashboard_card.dart';
import '../../auth/cubits/admin_auth_cubit.dart';
import '../../auth/cubits/admin_auth_state.dart';
import 'change_password_dialog.dart';

// Administrator account profile card
class AdminAccountCard extends StatelessWidget {
  const AdminAccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminAuthCubit, AdminAuthState>(
      builder: (context, authState) {
        final user = authState.user;
        final displayName = user?.displayName.isNotEmpty == true
            ? user!.displayName
            : 'Store Administrator';
        final email = user?.email.isNotEmpty == true
            ? user!.email
            : 'admin@shopease.com';
        final initial = displayName.isNotEmpty
            ? displayName[0].toUpperCase()
            : 'A';

        return DashboardCard(
          padding: const EdgeInsets.all(AppSizes.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSizes.sm),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: const Icon(
                      IconsaxPlusLinear.shield_security,
                      color: AppColors.primary,
                      size: AppSizes.iconMd,
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Administrator Account', style: AppTextStyles.h3),
                        const SizedBox(height: AppSizes.xxs),
                        Text(
                          'Session credentials, security actions, and role permissions',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
              const Divider(height: 1, thickness: 1, color: AppColors.divider),
              const SizedBox(height: AppSizes.lg),

              // Account Identity & Actions
              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile =
                      constraints.maxWidth <
                      DashboardConstants.mobileBreakpoint;

                  final identitySection = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Avatar with active indicator
                      Stack(
                        children: [
                          Container(
                            width: DashboardConstants.adminAvatarSize,
                            height: DashboardConstants.adminAvatarSize,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.primaryDark,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusMd,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.25,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              initial,
                              style: AppTextStyles.h3.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.surface,
                                  width: 2.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: AppSizes.md),

                      // User Info
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    displayName,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: AppSizes.sm),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.sm,
                                    vertical: AppSizes.xxs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.radiusSm,
                                    ),
                                    border: Border.all(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'SUPER ADMIN',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSizes.xxs),
                            Text(
                              email,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );

                  final actionsSection = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppButton.compact(
                        label: 'Change Password',
                        icon: IconsaxPlusLinear.key,
                        isOutlined: true,
                        onPressed: () => ChangePasswordDialog.show(context),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      AppButton.compact(
                        label: 'Sign Out',
                        icon: IconsaxPlusLinear.logout,
                        isDestructive: true,
                        onPressed: () => _confirmSignOut(context),
                      ),
                    ],
                  );

                  if (isMobile) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        identitySection,
                        const SizedBox(height: AppSizes.lg),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: actionsSection,
                        ),
                      ],
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: identitySection),
                      const SizedBox(width: AppSizes.md),
                      actionsSection,
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          title: Text(
            'Confirm Sign Out',
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Are you sure you want to end your administrative session?',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            AppButton.compact(
              label: 'Sign Out',
              isDestructive: true,
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AdminAuthCubit>().logout();
              },
            ),
          ],
        );
      },
    );
  }
}
