import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../dashboard/constants/dashboard_constants.dart';

// Dialog for updating the admin password
class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const ChangePasswordDialog(),
    );
  }

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    Navigator.of(context).pop();
    AppSnackBar.showSuccess(
      context,
      'Administrator password updated successfully',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.lg,
      ),
      child: Container(
        width: DashboardConstants.settingsDialogWidth,
        padding: const EdgeInsets.all(AppSizes.xl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.12),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                      IconsaxPlusLinear.key,
                      color: AppColors.primary,
                      size: AppSizes.iconMd,
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Change Password', style: AppTextStyles.h3),
                        const SizedBox(height: AppSizes.xxs),
                        Text(
                          'Update your administrator credentials',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      IconsaxPlusLinear.close_circle,
                      size: AppSizes.iconMd,
                      color: AppColors.textHint,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
              const Divider(height: 1, thickness: 1, color: AppColors.divider),
              const SizedBox(height: AppSizes.lg),

              // Current Password
              AppTextField(
                controller: _currentPasswordController,
                label: 'Current Password',
                hintText: 'Enter your existing password',
                prefixIcon: IconsaxPlusLinear.lock_1,
                isPassword: true,
                validator: AppValidators.validatePassword,
              ),
              const SizedBox(height: AppSizes.md),

              // New Password
              AppTextField(
                controller: _newPasswordController,
                label: 'New Password',
                hintText: 'Enter new password (min. 6 characters)',
                prefixIcon: IconsaxPlusLinear.lock,
                isPassword: true,
                validator: (val) => AppValidators.validateNewPassword(
                  val,
                  _currentPasswordController.text,
                ),
              ),
              const SizedBox(height: AppSizes.md),

              // Confirm Password
              AppTextField(
                controller: _confirmPasswordController,
                label: 'Confirm New Password',
                hintText: 'Re-enter your new password',
                prefixIcon: IconsaxPlusLinear.shield_tick,
                isPassword: true,
                validator: (val) => AppValidators.validateConfirmPassword(
                  val,
                  _newPasswordController.text,
                ),
              ),
              const SizedBox(height: AppSizes.xl),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton.compact(
                    label: 'Cancel',
                    isOutlined: true,
                    onPressed: _isLoading
                        ? null
                        : () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  AppButton.compact(
                    label: _isLoading ? 'Updating...' : 'Update Password',
                    icon: IconsaxPlusLinear.tick_circle,
                    isLoading: _isLoading,
                    onPressed: _isLoading ? null : _handleSubmit,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
