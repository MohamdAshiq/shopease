import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../models/admin_nav_destination.dart';
import 'components/menu_tile.dart';
import 'logout_button.dart';

// Sidebar Menu Widget
class AdminSidebar extends StatelessWidget {
  const AdminSidebar({
    super.key,
    required this.selectedDestination,
    required this.onDestinationSelected,
    this.isCompact = false,
    this.adminName = 'ShopEase Admin',
    required this.adminEmail,
    required this.onLogout,
  });

  static const double sidebarWidth = 250.0;
  static const double sidebarCompactWidth = 76.0;

  final AdminNavDestination selectedDestination;
  final ValueChanged<AdminNavDestination> onDestinationSelected;
  final bool isCompact;
  final String adminName;
  final String adminEmail;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final width = isCompact ? sidebarCompactWidth : sidebarWidth;

    return Container(
      width: width,
      color: AppColors.sidebarBackground,
      child: Column(
        children: [
          // Logo Area
          if (isCompact)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.xl),
              child: _buildLogoBadge(),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSizes.xl,
                horizontal: AppSizes.lg,
              ),
              child: Row(
                children: [
                  _buildLogoBadge(),
                  const SizedBox(width: AppSizes.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SHOPEASE',
                        style: AppTextStyles.h3.copyWith(
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'ADMIN CONSOLE',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white54,
                          letterSpacing: 1.5,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppSizes.md),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? AppSizes.xs : AppSizes.md,
              ),
              children: AdminNavDestination.values.map((destination) {
                return MenuTile(
                  icon: destination.icon,
                  selectedIcon: destination.selectedIcon,
                  title: destination.label,
                  isActive: selectedDestination == destination,
                  isCompact: isCompact,
                  onTap: () => onDestinationSelected(destination),
                );
              }).toList(),
            ),
          ),

          // Admin Profile Area & Logout Button
          if (isCompact)
            Container(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
              margin: const EdgeInsets.all(AppSizes.xs),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    child: const Icon(
                      IconsaxPlusBold.profile,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  LogoutButton(onConfirm: onLogout),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(AppSizes.md),
              margin: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    child: const Icon(
                      IconsaxPlusBold.profile,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          adminName,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          adminEmail,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white54,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Logout Button
                  LogoutButton(onConfirm: onLogout),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLogoBadge() {
    return Container(
      width: 44,
      height: 44,
      padding: const EdgeInsets.all(AppSizes.xs + 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Image.asset(
        AppAssets.appLogo,
        package: AppAssets.package,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Icon(
          IconsaxPlusBold.bag_2,
          color: AppColors.primary,
          size: 22,
        ),
      ),
    );
  }
}
