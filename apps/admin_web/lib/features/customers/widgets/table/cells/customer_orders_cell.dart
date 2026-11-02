import 'package:admin_web/features/customers/models/customer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Orders count badge cell
class CustomerOrdersCell extends StatelessWidget {
  const CustomerOrdersCell({super.key, required this.customer});

  final CustomerViewModel customer;

  @override
  Widget build(BuildContext context) {
    final count = customer.orderCount;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.md,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.sm,
              vertical: AppSizes.xxs,
            ),
            decoration: BoxDecoration(
              color: count > 0
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : AppColors.scaffoldBackground,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              border: Border.all(
                color: count > 0
                    ? AppColors.primary.withValues(alpha: 0.25)
                    : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  IconsaxPlusLinear.bag_2,
                  size: AppSizes.iconSm - 4,
                  color: count > 0
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: AppSizes.xs),
                Text(
                  '$count ${count == 1 ? 'order' : 'orders'}',
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: count > 0
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
