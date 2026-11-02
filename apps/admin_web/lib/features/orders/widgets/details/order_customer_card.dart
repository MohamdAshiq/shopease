import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Customer details and shipping address card for details drawer
class OrderCustomerCard extends StatelessWidget {
  const OrderCustomerCard({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final addr = order.deliveryAddress;
    final addressText = [
      if (addr.street.isNotEmpty) addr.street,
      if (addr.city.isNotEmpty) addr.city,
      if (addr.state.isNotEmpty) addr.state,
      if (addr.postalCode.isNotEmpty) addr.postalCode,
      if (addr.country.isNotEmpty) addr.country,
    ].join(', ');

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                IconsaxPlusLinear.user,
                size: AppSizes.iconSm,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSizes.xs + 2),
              Text(
                'Customer & Delivery',
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),

          // Customer Profile Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  order.customerName.isNotEmpty
                      ? order.customerName[0].toUpperCase()
                      : 'U',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customerName,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.customerEmail,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (order.customerPhone.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        order.customerPhone,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.md),
          const Divider(height: 1, thickness: 0.8, color: AppColors.divider),
          const SizedBox(height: AppSizes.md),

          // Shipping Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                IconsaxPlusLinear.location,
                size: AppSizes.iconSm,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Address',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      addr.recipientName?.isNotEmpty == true
                          ? '${addr.recipientName}'
                          : order.customerName,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      addressText.isNotEmpty
                          ? addressText
                          : 'No address provided',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
