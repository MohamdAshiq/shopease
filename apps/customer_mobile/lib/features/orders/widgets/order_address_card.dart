import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../widgets/section_card_header.dart';

// Address Card in Order Detail Screen
class OrderAddressCard extends StatelessWidget {
  const OrderAddressCard({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionCardHeader(
            icon: IconsaxPlusBold.location,
            title: 'Delivery Details',
          ),
          if (order.deliveryAddress.recipientName?.isNotEmpty == true) ...[
            Text(
              order.deliveryAddress.recipientName!,
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSizes.xs + 2),
          ],
          Text(
            order.deliveryAddress.formattedAddress,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          if (order.deliveryAddress.phone?.isNotEmpty == true) ...[
            const SizedBox(height: AppSizes.sm),
            Row(
              children: [
                const Icon(
                  IconsaxPlusLinear.call,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppSizes.xs),
                Text(
                  order.deliveryAddress.phone!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
