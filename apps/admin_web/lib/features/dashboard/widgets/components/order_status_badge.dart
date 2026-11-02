import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../constants/dashboard_constants.dart';

// Order status pill badge
class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  final OrderStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final statusColor = status.statusColor;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6.0 : AppSizes.sm,
        vertical: compact ? 2.0 : AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: compact ? 4.5 : DashboardConstants.statusIndicatorDotSize,
              height: compact ? 4.5 : DashboardConstants.statusIndicatorDotSize,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: compact ? 4.0 : AppSizes.xs),
            Text(
              status.displayName,
              style: AppTextStyles.labelSmall.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
                fontSize: compact ? 10.5 : 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
