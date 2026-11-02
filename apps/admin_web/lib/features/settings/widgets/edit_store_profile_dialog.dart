import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../dashboard/constants/dashboard_constants.dart';
import '../cubits/admin_settings_cubit.dart';
import '../cubits/admin_settings_state.dart';

//  Dialog for editing the public store branding and contact info
class EditStoreProfileDialog extends StatefulWidget {
  const EditStoreProfileDialog({super.key, required this.cubit});

  final AdminSettingsCubit cubit;

  static Future<void> show(BuildContext context) {
    final cubit = context.read<AdminSettingsCubit>();
    return showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: EditStoreProfileDialog(cubit: cubit),
      ),
    );
  }

  @override
  State<EditStoreProfileDialog> createState() => _EditStoreProfileDialogState();
}

class _EditStoreProfileDialogState extends State<EditStoreProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final state = widget.cubit.state;
    _nameController = TextEditingController(text: state.storeName);
    _emailController = TextEditingController(text: state.supportEmail);
    _phoneController = TextEditingController(text: state.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await widget.cubit.updateStoreProfile(
      storeName: _nameController.text,
      supportEmail: _emailController.text,
      phone: _phoneController.text,
    );

    if (!mounted) return;
    Navigator.of(context).pop();
    AppSnackBar.showSuccess(context, 'Store profile updated successfully');
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
                      IconsaxPlusLinear.shop,
                      color: AppColors.primary,
                      size: AppSizes.iconMd,
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Edit Store Profile', style: AppTextStyles.h3),
                        const SizedBox(height: AppSizes.xxs),
                        Text(
                          'Update public brand identity and support contacts',
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

              // Store Name
              AppTextField(
                controller: _nameController,
                label: 'Store Brand Name',
                hintText: 'Enter store name',
                prefixIcon: IconsaxPlusLinear.shop,
                validator: (val) =>
                    AppValidators.validateRequired(val, 'store name'),
              ),
              const SizedBox(height: AppSizes.md),

              // Support Email
              AppTextField(
                controller: _emailController,
                label: 'Customer Support Email',
                hintText: 'support@yourstore.com',
                prefixIcon: IconsaxPlusLinear.sms,
                keyboardType: TextInputType.emailAddress,
                validator: AppValidators.validateEmail,
              ),
              const SizedBox(height: AppSizes.md),

              // Support Phone
              AppTextField(
                controller: _phoneController,
                label: 'Contact Support Phone',
                hintText: '+91 80 0000 0000',
                prefixIcon: IconsaxPlusLinear.call,
                keyboardType: TextInputType.phone,
                validator: AppValidators.validatePhone,
              ),
              const SizedBox(height: AppSizes.xl),

              // Action Buttons
              BlocBuilder<AdminSettingsCubit, AdminSettingsState>(
                builder: (context, state) {
                  final isSaving = state.isSaving;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppButton.compact(
                        label: 'Cancel',
                        isOutlined: true,
                        onPressed: isSaving
                            ? null
                            : () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      AppButton.compact(
                        label: isSaving ? 'Saving...' : 'Save Changes',
                        icon: IconsaxPlusLinear.tick_circle,
                        isLoading: isSaving,
                        onPressed: isSaving ? null : _handleSave,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
