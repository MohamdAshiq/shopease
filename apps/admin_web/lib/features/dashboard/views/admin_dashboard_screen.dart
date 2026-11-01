import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/admin_route_constants.dart';
import '../../auth/cubits/admin_auth_cubit.dart';
import '../../auth/cubits/admin_auth_state.dart';

// Admin Dashboard Screen
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminAuthCubit, AdminAuthState>(
      listener: (context, state) {
        if (!state.isAuthenticated) {
          context.go(AdminRoutePaths.login);
        }
      },
      builder: (context, state) {
        final admin = state.user ?? mockAdmin;

        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            title: const Text('ShopEase Admin'),
            actions: [
              TextButton.icon(
                onPressed: () {
                  context.read<AdminAuthCubit>().logout();
                },
                icon: const Icon(IconsaxPlusLinear.logout, size: 16),
                label: const Text('Logout'),
              ),
              const SizedBox(width: AppSizes.md),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Admin Dashboard', style: AppTextStyles.h2),
                const SizedBox(height: AppSizes.xs),
                Text(
                  'Signed in as ${admin.email}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
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
