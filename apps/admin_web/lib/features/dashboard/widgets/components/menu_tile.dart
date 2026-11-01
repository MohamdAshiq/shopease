import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Sidebar Menu Item Tile
class MenuTile extends StatelessWidget {
  final IconData icon;
  final IconData? selectedIcon;
  final String title;
  final bool isActive;
  final VoidCallback onTap;
  final int? badgeCount;
  final bool isCompact;

  const MenuTile({
    super.key,
    required this.icon,
    this.selectedIcon,
    required this.title,
    required this.isActive,
    required this.onTap,
    this.badgeCount,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIcon = (isActive && selectedIcon != null)
        ? selectedIcon!
        : icon;

    if (isCompact) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.xs),
        child: Tooltip(
          message: title,
          preferBelow: false,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Center(
                child: Icon(
                  effectiveIcon,
                  color: isActive ? Colors.white : Colors.white60,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.xs),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm + 4,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Row(
          children: [
            Icon(
              effectiveIcon,
              color: isActive ? Colors.white : Colors.white60,
              size: 20,
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isActive ? Colors.white : Colors.white70,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (badgeCount != null)
              Container(
                padding: const EdgeInsets.all(AppSizes.xs + 2),
                decoration: const BoxDecoration(
                  color: AppColors.warning,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badgeCount.toString(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
