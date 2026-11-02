import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Reusable Order Status Badge / Pill
class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({
    super.key,
    required this.status,
    this.showDot = false,
    this.isUppercase = false,
    this.padding,
  });

  final OrderStatus status;
  final bool showDot;
  final bool isUppercase;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final statusColor = status.statusColor;
    final text = isUppercase
        ? status.displayName.toUpperCase()
        : status.displayName;

    return Container(
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: showDot ? AppSizes.sm + 2 : AppSizes.sm,
            vertical: AppSizes.xs,
          ),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: AppSizes.sm - 2,
              height: AppSizes.sm - 2,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSizes.xs + 2),
          ],
          Text(
            text,
            style: AppTextStyles.labelSmall.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w700,
              letterSpacing: isUppercase ? 0.4 : null,
            ),
          ),
        ],
      ),
    );
  }
}
