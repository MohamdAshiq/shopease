import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../cubits/admin_auth_cubit.dart';
import '../cubits/admin_auth_state.dart';

// Admin Login Form Widget
class AdminLoginForm extends StatefulWidget {
  const AdminLoginForm({super.key, required this.isDesktop});

  final bool isDesktop;

  @override
  State<AdminLoginForm> createState() => _AdminLoginFormState();
}

class _AdminLoginFormState extends State<AdminLoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // Pre-fill mock admin credentials
  void _fillDemoCredentials() {
    setState(() {
      _emailController.text = mockAdmin.email;
      _passwordController.text = 'admin123';
    });
  }

  // Submit login form
  void _handleLogin() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AdminAuthCubit>().login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminAuthCubit, AdminAuthState>(
      builder: (context, authState) {
        return Container(
          color: AppColors.surface,
          constraints: BoxConstraints(
            minHeight: widget.isDesktop
                ? MediaQuery.of(context).size.height
                : 0,
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isDesktop ? AppSizes.xxl : AppSizes.lg,
                vertical: AppSizes.xxl,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header tag
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusSm,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  IconsaxPlusLinear.shield_security,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Restricted Access',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.md),

                      // Title & Subtitle
                      Text(
                        'Admin Sign In',
                        style: AppTextStyles.h2.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        'Sign in to manage catalog, orders and customer accounts.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSizes.lg),

                      // Demo credentials quick pill
                      InkWell(
                        onTap: _fillDemoCredentials,
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.md,
                            vertical: AppSizes.sm + 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.scaffoldBackground,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusMd,
                            ),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                IconsaxPlusLinear.flash_1,
                                size: 18,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: AppSizes.sm),
                              Expanded(
                                child: Text(
                                  'Fill Demo Admin Credentials',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Icon(
                                IconsaxPlusLinear.arrow_right_3,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.xl),

                      // Email Field
                      AppTextField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        label: 'Email Address',
                        hintText: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            _passwordFocusNode.requestFocus(),
                        validator: AppValidators.validateEmail,
                        prefixIcon: IconsaxPlusLinear.sms,
                        borderless: false,
                        fillColor: AppColors.scaffoldBackground,
                      ),
                      const SizedBox(height: AppSizes.lg),

                      // Password Field
                      AppTextField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        label: 'Password',
                        hintText: 'Enter your password',
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleLogin(),
                        validator: AppValidators.validatePassword,
                        prefixIcon: IconsaxPlusLinear.lock,
                        borderless: false,
                        fillColor: AppColors.scaffoldBackground,
                      ),
                      const SizedBox(height: AppSizes.xl),

                      // Sign In Button
                      AppButton(
                        label: 'Sign In to Dashboard',
                        icon: IconsaxPlusLinear.login,
                        isLoading: authState.isLoading,
                        isFullWidth: true,
                        onPressed: _handleLogin,
                      ),
                      const SizedBox(height: AppSizes.xl),

                      // Footer Security Note
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            IconsaxPlusLinear.security_safe,
                            size: 16,
                            color: AppColors.textHint,
                          ),
                          const SizedBox(width: AppSizes.sm),
                          Flexible(
                            child: Text(
                              'Protected by ShopEase Security',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textHint,
                                fontSize: 11,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
