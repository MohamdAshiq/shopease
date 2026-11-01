import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';
import '../../../widgets/app_top_bar.dart';
import '../../auth/widgets/auth_prompt_sheet.dart';
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
    final profileState = context.watch<ProfileCubit>().state;
    final notificationsEnabled = profileState.notificationsEnabled;
    final isAuthenticated = profileState.isAuthenticated;

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
            // Profile Header Card
            const ProfileHeaderCard(),
            const SizedBox(height: AppSizes.md),

            // Settings Card
            ProfileMenuGroup(
              children: [
                // My Orders
                ProfileMenuTile(
                  icon: IconsaxPlusLinear.bag_2,
                  title: 'My Orders',
                  onTap: () {
                    if (isAuthenticated) {
                      context.push(RoutePaths.orders);
                    } else {
                      AuthPromptSheet.show(
                        context,
                        title: 'Sign In to View Orders',
                        subtitle: 'Sign in or create an account to track deliveries, view invoices, and reorder items.',
                        redirectPath: RoutePaths.orders,
                        icon: IconsaxPlusBold.bag_2,
                        onAuthenticated: () {
                          context.push(RoutePaths.orders);
                        },
                      );
                    }
                  },
                ),

                // Shipping Addresses
                ProfileMenuTile(
                  icon: IconsaxPlusLinear.location,
                  title: 'Shipping Addresses',
                  onTap: () {
                    if (isAuthenticated) {
                      context.push(RoutePaths.addresses);
                    } else {
                      AuthPromptSheet.show(
                        context,
                        title: 'Sign In for Addresses',
                        subtitle: 'Sign in to access, add, and manage your saved delivery addresses.',
                        redirectPath: RoutePaths.addresses,
                        icon: IconsaxPlusBold.location,
                        onAuthenticated: () {
                          context.push(RoutePaths.addresses);
                        },
                      );
                    }
                  },
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

                // Sign Out Tile
                if (isAuthenticated)
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
