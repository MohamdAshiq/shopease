import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Bottom Navigation Shell
class CustomerShell extends StatelessWidget {
  const CustomerShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: navigationShell.currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          navigationShell.goBranch(0);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          backgroundColor: AppColors.background,
          elevation: 4,
          height: AppSizes.bottomNavHeight,
          indicatorColor: AppColors.primary.withValues(alpha: 0.12),
          destinations: const [
            // Home
            NavigationDestination(
              icon: Icon(IconsaxPlusLinear.home_2),
              selectedIcon: Icon(
                IconsaxPlusBold.home_2,
                color: AppColors.primary,
              ),
              label: 'Home',
            ),

            // Store
            NavigationDestination(
              icon: Icon(IconsaxPlusLinear.shop),
              selectedIcon: Icon(
                IconsaxPlusBold.shop,
                color: AppColors.primary,
              ),
              label: 'Store',
            ),

            // Wishlist
            NavigationDestination(
              icon: Icon(IconsaxPlusLinear.heart),
              selectedIcon: Icon(
                IconsaxPlusBold.heart,
                color: AppColors.primary,
              ),
              label: 'Wishlist',
            ),

            // Profile
            NavigationDestination(
              icon: Icon(IconsaxPlusLinear.user),
              selectedIcon: Icon(
                IconsaxPlusBold.user,
                color: AppColors.primary,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
