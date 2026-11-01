import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';
import '../../../widgets/app_brand_logo.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';
import '../widgets/auth_footer.dart';

// Login Screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.redirect});

  final String? redirect;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSuccess() {
    AppSnackBar.showSuccess(context, 'Signed in successfully');
    final redirectPath = widget.redirect;
    if (redirectPath != null && redirectPath.isNotEmpty) {
      context.go(redirectPath);
    } else if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.go(RoutePaths.home);
    }
  }

  Future<void> _submitLogin() async {
    HapticFeedback.lightImpact();
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final success = await context.read<AuthCubit>().signIn(
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
      'Sign in to complete your checkout and place your order.',
    RoutePaths.orders =>
      'Sign in to track deliveries and view your order history.',
    RoutePaths.addresses =>
      'Sign in to access and manage your saved addresses.',
    _ => 'Please enter your email & password to sign in.',
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

                      // Welcome Msg
                      Text('Welcome back 👋', style: AppTextStyles.h2),
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
                        onFieldSubmitted: (_) => _submitLogin(),
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

                      // Remember me + Forgot password
                      Row(
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              setState(() {
                                _rememberMe = !_rememberMe;
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: AppSizes.checkboxSize,
                                  width: AppSizes.checkboxSize,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    onChanged: (v) {
                                      setState(() {
                                        _rememberMe = v ?? false;
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
                                Text(
                                  'Remember me',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              context.pushNamed(RouteNames.forgotPassword);
                            },
                            child: Text(
                              'Forgot Password?',
                              style: AppTextStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.lg),

                      // Sign In Button
                      AppButton(
                        label: 'Sign In',
                        isFullWidth: true,
                        height: AppSizes.inputHeight,
                        borderRadius: AppSizes.radiusMd,
                        isLoading: state.isLoading,
                        onPressed: state.isLoading ? null : _submitLogin,
                      ),
                      const SizedBox(height: AppSizes.lg),

                      // Auth Footer
                      AuthFooter(
                        onGoogleAuthSuccess: _handleSuccess,
                        promptText: "Don't have an account? ",
                        actionText: 'Sign up',
                        onActionTap: () {
                          context.pushNamed(
                            RouteNames.register,
                            queryParameters: widget.redirect != null
                                ? {'redirect': widget.redirect!}
                                : const {},
                          );
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
