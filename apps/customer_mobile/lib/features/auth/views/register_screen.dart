import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';
import '../widgets/auth_footer.dart';

// Register Screen
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.redirect});

  final String? redirect;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSuccess() {
    AppSnackBar.showSuccess(
      context,
      'Account created successfully! Welcome to ShopEase.',
    );
    final redirectPath = widget.redirect;
    if (redirectPath != null && redirectPath.isNotEmpty) {
      context.go(redirectPath);
    } else if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.go(RoutePaths.home);
    }
  }

  Future<void> _submitRegister() async {
    HapticFeedback.lightImpact();
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (!_agreeToTerms) {
      AppSnackBar.showError(context, 'Please agree to the Terms & Conditions');
      return;
    }

    final success = await context.read<AuthCubit>().register(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;
    if (success) {
      _handleSuccess();
    }
  }

  String get _subtitle => switch (widget.redirect) {
    RoutePaths.checkout =>
      'Create an account to complete your checkout and place your order.',
    RoutePaths.orders =>
      'Create an account to track deliveries and view orders.',
    RoutePaths.addresses => 'Create an account to manage your saved addresses.',
    _ => 'Fill in your details to continue and get started.',
  };

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.hasError && state.errorMessage != null) {
          AppSnackBar.showError(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        final canPop = Navigator.of(context).canPop();
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: canPop
              ? AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  toolbarHeight: 44.0,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )
              : null,
          body: SafeArea(
            top: !canPop,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPadding,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: canPop ? AppSizes.xs : AppSizes.md),

                      // App Logo
                      const AppBrandLogo(size: AppSizes.logoSize),
                      const SizedBox(height: AppSizes.sm),

                      // Create Account Msg
                      Text('Create Account 🎉', style: AppTextStyles.h2),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        _subtitle,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.xxl),

                      // Full Name
                      AppTextField(
                        hintText: 'Full Name',
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        validator: (v) =>
                            AppValidators.validateRequired(v, 'full name'),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.lg - 4,
                          vertical: AppSizes.md + 2,
                        ),
                        prefixWidget: const Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.textHint,
                          size: AppSizes.iconSm + AppSizes.xs,
                        ),
                      ),
                      const SizedBox(height: AppSizes.md),

                      // Email
                      AppTextField(
                        hintText: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: AppValidators.validateEmail,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.lg - 4,
                          vertical: AppSizes.md + 2,
                        ),
                        prefixWidget: const Icon(
                          Icons.email_outlined,
                          color: AppColors.textHint,
                          size: AppSizes.iconSm + AppSizes.xs,
                        ),
                      ),
                      const SizedBox(height: AppSizes.md),

                      // Password
                      AppTextField(
                        hintText: 'Password',
                        controller: _passwordController,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submitRegister(),
                        validator: AppValidators.validatePassword,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.lg - 4,
                          vertical: AppSizes.md + 2,
                        ),
                        prefixWidget: const Icon(
                          Icons.lock_outline_rounded,
                          color: AppColors.textHint,
                          size: AppSizes.iconSm + AppSizes.xs,
                        ),
                      ),
                      const SizedBox(height: AppSizes.md),

                      // Terms & Conditions
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            _agreeToTerms = !_agreeToTerms;
                          });
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              height: AppSizes.checkboxSize,
                              width: AppSizes.checkboxSize,
                              child: Checkbox(
                                value: _agreeToTerms,
                                onChanged: (v) {
                                  setState(() {
                                    _agreeToTerms = v ?? false;
                                  });
                                },
                                activeColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.xs,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSizes.sm),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                  children: [
                                    const TextSpan(text: 'I agree to the '),
                                    TextSpan(
                                      text: 'Terms & Conditions',
                                      style: AppTextStyles.labelMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSizes.lg),

                      // Sign Up Button
                      AppButton(
                        label: 'Sign Up',
                        isFullWidth: true,
                        height: AppSizes.inputHeight,
                        borderRadius: AppSizes.radiusMd,
                        isLoading: state.isLoading,
                        onPressed: state.isLoading ? null : _submitRegister,
                      ),
                      const SizedBox(height: AppSizes.lg),

                      // Auth Footer
                      AuthFooter(
                        onGoogleAuthSuccess: _handleSuccess,
                        promptText: 'Already have an account? ',
                        actionText: 'Sign in',
                        onActionTap: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          } else {
                            context.goNamed(
                              RouteNames.login,
                              queryParameters: widget.redirect != null
                                  ? {'redirect': widget.redirect!}
                                  : const {},
                            );
                          }
                        },
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
