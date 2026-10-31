import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';
import '../../../widgets/app_top_bar.dart';
import '../cubits/profile_cubit.dart';
import '../widgets/help_support_dialog.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_menu_group.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/sign_out_dialog.dart';

// Customer Profile Screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationsEnabled = context
        .watch<ProfileCubit>()
        .state
        .notificationsEnabled;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: const AppTopBar(title: 'Profile', showBack: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.screenPadding,
          AppSizes.sm + 4,
          AppSizes.screenPadding,
          AppSizes.xl,
        ),
        child: Column(
          children: [
            // User Header Card
            const ProfileHeaderCard(),
            const SizedBox(height: AppSizes.md),

            // Settings Card
            ProfileMenuGroup(
              children: [
                // My Orders
                ProfileMenuTile(
                  icon: IconsaxPlusLinear.bag_2,
                  title: 'My Orders',
                  onTap: () => context.push(RoutePaths.orders),
                ),

                // Shipping Addresses
                ProfileMenuTile(
                  icon: IconsaxPlusLinear.location,
                  title: 'Shipping Addresses',
                  onTap: () => context.push(RoutePaths.addresses),
                ),

                // Push Notifications
                ProfileMenuTile(
                  icon: IconsaxPlusLinear.notification,
                  title: 'Push Notifications',
                  trailing: Transform.scale(
                    scale: 0.78,
                    alignment: Alignment.centerRight,
                    child: Switch.adaptive(
                      value: notificationsEnabled,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) {
                        context.read<ProfileCubit>().toggleNotifications(val);
                        AppSnackBar.show(
                          context,
                          message: val
                              ? 'Push notifications enabled'
                              : 'Push notifications disabled',
                          duration: const Duration(seconds: 2),
                        );
                      },
                    ),
                  ),
                ),

                // Help & Support
                ProfileMenuTile(
                  icon: IconsaxPlusLinear.message_question,
                  title: 'Help & Support',
                  onTap: () => HelpSupportDialog.show(context),
                ),

                // Sign Out
                ProfileMenuTile(
                  icon: IconsaxPlusLinear.logout,
                  title: 'Sign Out',
                  isDestructive: true,
                  onTap: () => SignOutDialog.show(context),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),

            // App version
            Text(
              'ShopEase v1.0.0',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
