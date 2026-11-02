import 'package:admin_web/features/customers/models/customer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:shopease_core/theme/app_colors.dart';
import 'package:shopease_core/theme/app_sizes.dart';
import 'package:shopease_core/theme/app_text_styles.dart';
import 'package:shopease_core/utils/currency_formatter.dart';

// Customer lifetime spend (LTV) cell
class CustomerLtvCell extends StatelessWidget {
  const CustomerLtvCell({super.key, required this.customer});

  final CustomerViewModel customer;

  @override
  Widget build(BuildContext context) {
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
          child: Text(
            customer.lifetimeValue.inr2,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: customer.lifetimeValue > 0
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
