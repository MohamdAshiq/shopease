import 'package:flutter/material.dart';

import '../constants/order_status.dart';
import '../theme/app_sizes.dart';
import '../theme/app_text_styles.dart';

// Reusable Order Status Badge
class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({
    super.key,
    required this.status,
    this.showDot = false,
    this.compact = false,
    this.isUppercase = false,
    this.padding,
  });

  final OrderStatus status;
  final bool showDot;
  final bool compact;
  final bool isUppercase;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final statusColor = status.statusColor;
    final text = isUppercase
        ? status.displayName.toUpperCase()
        : status.displayName;

    final defaultPadding = EdgeInsets.symmetric(
      horizontal: compact ? 6.0 : (showDot ? AppSizes.sm + 2 : AppSizes.sm),
      vertical: compact ? 2.0 : AppSizes.xs,
    );

    final dotSize = compact ? 4.5 : (AppSizes.sm - 2);

    return Container(
      padding: padding ?? defaultPadding,
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(
          compact ? AppSizes.radiusSm : AppSizes.radiusFull,
        ),
        border: compact
            ? Border.all(color: statusColor.withValues(alpha: 0.3), width: 0.8)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot || compact) ...[
            Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: compact ? 4.0 : (AppSizes.xs + 2)),
          ],
          Text(
            text,
            style: AppTextStyles.labelSmall.copyWith(
              color: statusColor,
              fontWeight: compact ? FontWeight.w600 : FontWeight.w700,
              fontSize: compact ? 10.5 : null,
              letterSpacing: isUppercase ? 0.4 : null,
            ),
          ),
        ],
      ),
    );
  }
}
