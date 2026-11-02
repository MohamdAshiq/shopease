import 'package:admin_web/features/customers/models/customer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:shopease_core/theme/app_sizes.dart';
import 'package:shopease_core/theme/app_text_styles.dart';

// Customer tier chip badge cell
class CustomerTierCell extends StatelessWidget {
  const CustomerTierCell({super.key, required this.customer});

  final CustomerViewModel customer;

  @override
  Widget build(BuildContext context) {
    final tier = customer.tier;

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
              vertical: AppSizes.xxs + 1,
            ),
            decoration: BoxDecoration(
              color: tier.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              border: Border.all(
                color: tier.color.withValues(alpha: 0.3),
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(tier.icon, size: AppSizes.iconSm - 4, color: tier.color),
                const SizedBox(width: AppSizes.xs),
                Text(
                  tier.label,
                  style: AppTextStyles.badge.copyWith(
                    color: tier.color,
                    fontWeight: FontWeight.bold,
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
