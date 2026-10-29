import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shopease_core/shopease_core.dart';

import '../cubits/navigation_cubit.dart';
import 'home_screen.dart';

// Bottom Navigation Shell
class HomeNavScreen extends StatelessWidget {
  const HomeNavScreen({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    _PlaceholderTab(title: 'Store', icon: IconsaxPlusLinear.shop),
    _PlaceholderTab(title: 'Wishlist', icon: IconsaxPlusLinear.heart),
    _PlaceholderTab(title: 'Profile', icon: IconsaxPlusLinear.user),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            body: IndexedStack(index: currentIndex, children: _screens),
            bottomNavigationBar: NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                context.read<NavigationCubit>().setTab(index);
              },
              backgroundColor: AppColors.background,
              elevation: 4,
              height: AppSizes.bottomNavHeight,
              indicatorColor: AppColors.primary.withValues(alpha: 0.12),
              destinations: const [
                NavigationDestination(
                  icon: Icon(IconsaxPlusLinear.home_2),
                  selectedIcon: Icon(
                    IconsaxPlusBold.home_2,
                    color: AppColors.primary,
                  ),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(IconsaxPlusLinear.shop),
                  selectedIcon: Icon(
                    IconsaxPlusBold.shop,
                    color: AppColors.primary,
                  ),
                  label: 'Store',
                ),
                NavigationDestination(
                  icon: Icon(IconsaxPlusLinear.heart),
                  selectedIcon: Icon(
                    IconsaxPlusBold.heart,
                    color: AppColors.primary,
                  ),
                  label: 'Wishlist',
                ),
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
          );
        },
      ),
    );
  }
}

// PlaceHolder Screen
class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(title, style: AppTextStyles.h3),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppSizes.iconXl + AppSizes.sm,
              color: AppColors.textHint,
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              '$title Screen',
              style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
