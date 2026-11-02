import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../auth/cubits/auth_cubit.dart';
import '../cubits/profile_cubit.dart';

// Edit Customer Profile Bottom Sheet
class EditProfileBottomSheet extends StatefulWidget {
  const EditProfileBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    HapticFeedback.lightImpact();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EditProfileBottomSheet(),
    );
  }

  @override
  State<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _phoneFocusNode;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileCubit>().state.user;
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');

    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.lightImpact();

    setState(() => _isSaving = true);

    final profileCubit = context.read<ProfileCubit>();
    final authCubit = context.read<AuthCubit>();
    final currentUser = profileCubit.state.user ?? authCubit.currentUser;

    final newName = _nameController.text.trim();
    final newEmail = _emailController.text.trim();
    final newPhone = _phoneController.text.trim();

    // Update ProfileCubit local state
    profileCubit.updateProfile(
      displayName: newName,
      email: newEmail,
      phone: newPhone,
    );

    // Synchronize with Firebase Auth and Firestore if user is authenticated
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(
        displayName: newName,
        email: newEmail,
        phone: newPhone,
      );
      await authCubit.updateUser(updatedUser);
    }

    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.of(context).pop();
    AppSnackBar.showSuccess(context, 'Profile updated successfully');
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.screenPadding,
        AppSizes.radiusMd,
        AppSizes.screenPadding,
        AppSizes.md + bottomInset,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLg),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top handle
                Center(
                  child: Container(
                    width: 36,
                    height: AppSizes.xs,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(AppSizes.xs / 2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.sm),

                // Title row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Profile',
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        size: AppSizes.iconSm + AppSizes.xs,
                      ),
                      color: AppColors.textSecondary,
                      visualDensity: VisualDensity.compact,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.md),

                // Full Name Field
                AppTextField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  label: 'Full Name',
                  hintText: 'Enter your name',
                  prefixIcon: IconsaxPlusLinear.user,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
                  validator: (v) => AppValidators.validateRequired(v, 'name'),
                ),
                const SizedBox(height: AppSizes.md),

                // Email Field
                AppTextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  label: 'Email Address',
                  hintText: 'Enter email address',
                  prefixIcon: IconsaxPlusLinear.sms,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _phoneFocusNode.requestFocus(),
                  validator: AppValidators.validateEmail,
                ),
                const SizedBox(height: AppSizes.md),

                // Phone Field
                AppTextField(
                  controller: _phoneController,
                  focusNode: _phoneFocusNode,
                  label: 'Phone Number',
                  hintText: 'e.g. +91 98765 43210',
                  prefixIcon: IconsaxPlusLinear.call,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _onSave(),
                  validator: AppValidators.validatePhone,
                ),
                const SizedBox(height: AppSizes.lg),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    onPressed: _isSaving ? null : _onSave,
                    isLoading: _isSaving,
                    label: 'Save Changes',
                    icon: IconsaxPlusBold.tick_circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
