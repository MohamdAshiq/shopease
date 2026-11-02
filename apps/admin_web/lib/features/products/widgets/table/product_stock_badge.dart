import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../dashboard/constants/dashboard_constants.dart';

// Stock level badge
class ProductStockBadge extends StatelessWidget {
  const ProductStockBadge({
    super.key,
    required this.stock,
    required this.isAvailable,
  });

  final int stock;
  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    final Color badgeColor;
    final String label;

    if (!isAvailable || stock == 0) {
      badgeColor = AppColors.error;
      label = stock == 0 ? 'Out of stock' : 'Disabled';
    } else if (stock < DashboardConstants.lowStockThreshold) {
      badgeColor = AppColors.warning;
      label = '$stock low units';
    } else {
      badgeColor = AppColors.success;
      label = '$stock in stock';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs - 1,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: DashboardConstants.statusIndicatorDotSize,
            height: DashboardConstants.statusIndicatorDotSize,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSizes.xs),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: badgeColor,
                fontWeight: FontWeight.bold,
                fontSize: 10.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
