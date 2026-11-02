import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../dashboard/constants/dashboard_constants.dart';
import '../cubits/admin_settings_cubit.dart';
import '../widgets/admin_account_card.dart';
import '../widgets/store_identity_card.dart';
import '../widgets/system_status_footer.dart';

// Admin Settings Screen
class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminSettingsCubit(),
      child: const _SettingsContent(),
    );
  }
}

class _SettingsContent extends StatelessWidget {
  const _SettingsContent();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile =
            constraints.maxWidth < DashboardConstants.mobileBreakpoint;
        final horizontalPadding = isMobile ? AppSizes.md : AppSizes.xl;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: AppSizes.xl,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: DashboardConstants.productsTableMinWidth,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Store Profile Card
                  StoreIdentityCard(),
                  SizedBox(height: AppSizes.xl),

                  // Current Admin Profile & Session Actions
                  AdminAccountCard(),
                  SizedBox(height: AppSizes.lg),

                  // System Status & Platform Information
                  SystemStatusFooter(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
