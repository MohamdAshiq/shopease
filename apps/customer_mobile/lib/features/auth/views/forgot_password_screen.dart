import 'package:customer_mobile/app/routing/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/app_top_bar.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

// Forgot Password Screen
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitReset() async {
    HapticFeedback.lightImpact();
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final success = await context.read<AuthCubit>().resetPassword(
      email: _emailController.text,
    );

    if (!mounted) return;
    if (success) {
      AppSnackBar.showSuccess(
        context,
        'Password recovery instructions sent to your email.',
      );
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        context.go(RoutePaths.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.hasError && state.errorMessage != null) {
          AppSnackBar.showError(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const AppTopBar(title: 'Forgot Password'),
          body: SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: AppSizes.lg),

                            // Subtitle
                            Text(
                              'Enter your registered email address to find your account.',
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSizes.lg),

                            // Email field
                            AppTextField(
                              hintText: 'Email',
                              controller: _emailController,
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
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submitReset(),
                            ),

                            const Spacer(),

                            // Continue button
                            AppButton(
                              label: 'Continue',
                              isFullWidth: true,
                              height: AppSizes.inputHeight,
                              borderRadius: AppSizes.radiusMd,
                              isLoading: state.isLoading,
                              onPressed: state.isLoading ? null : _submitReset,
                            ),
                            const SizedBox(height: AppSizes.xl),
                          ],
                        ),
                      ),
                    ),
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
