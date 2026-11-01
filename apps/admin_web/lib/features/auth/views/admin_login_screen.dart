import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/admin_route_constants.dart';
import '../cubits/admin_auth_cubit.dart';
import '../cubits/admin_auth_state.dart';
import '../widgets/admin_branding_side.dart';
import '../widgets/admin_login_form.dart';

// Admin Login Screen with Responsive Layout
class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 900;

    return BlocListener<AdminAuthCubit, AdminAuthState>(
      listenWhen: (prev, current) =>
          prev.errorMessage != current.errorMessage ||
          prev.isAuthenticated != current.isAuthenticated,
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackBar.showError(context, state.errorMessage!);
          context.read<AdminAuthCubit>().clearError();
        } else if (state.isAuthenticated) {
          AppSnackBar.showSuccess(
            context,
            'Welcome back, ${state.user?.displayName ?? "Admin"}!',
          );
          context.go(AdminRoutePaths.dashboard);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF160D2E),
        body: isDesktop
            ? const Row(
                children: [
                  Expanded(flex: 5, child: AdminBrandingSide(isDesktop: true)),
                  Expanded(flex: 4, child: AdminLoginForm(isDesktop: true)),
                ],
              )
            : const SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AdminBrandingSide(isDesktop: false),
                    AdminLoginForm(isDesktop: false),
                  ],
                ),
              ),
      ),
    );
  }
}
