import 'package:admin_web/features/customers/models/customer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

// Customer Contact Cell (Email + Phone)
class CustomerContactCell extends StatelessWidget {
  const CustomerContactCell({super.key, required this.customer});

  final CustomerViewModel customer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  customer.email,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: AppSizes.xs),
                IconButton(
                  icon: const Icon(
                    IconsaxPlusLinear.copy,
                    size: AppSizes.iconSm - 4,
                    color: AppColors.textSecondary,
                  ),
                  tooltip: 'Copy Email',
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: customer.email));
                    AppSnackBar.show(
                      context,
                      message: '${customer.email} copied to clipboard',
                      duration: const Duration(seconds: 1),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.xxs),
          Text(
            customer.phone.isNotEmpty ? customer.phone : 'No phone recorded',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
