import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Order status pill badge
class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm + AppSizes.xs / 2,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: status.statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Text(
        status.displayName,
        style: AppTextStyles.labelSmall.copyWith(
          color: status.statusColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
