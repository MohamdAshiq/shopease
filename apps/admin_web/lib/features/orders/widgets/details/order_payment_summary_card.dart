import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Payment summary card for details drawer
class OrderPaymentSummaryCard extends StatelessWidget {
  const OrderPaymentSummaryCard({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final method = order.paymentMethod;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    IconsaxPlusLinear.receipt_item,
                    size: AppSizes.iconSm,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSizes.xs + 2),
                  Text(
                    'Payment & Summary',
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    method.linearIcon,
                    size: AppSizes.iconSm - 2,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSizes.xs),
                  Text(
                    method.shortLabel,
                    style: AppTextStyles.labelSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),

          // Breakdown
          _buildRow('Subtotal', order.subtotal.inr2),
          const SizedBox(height: AppSizes.xs + 2),
          _buildRow(
            'Delivery Fee',
            order.deliveryFee == 0 ? 'FREE' : order.deliveryFee.inr2,
            isDiscount: order.deliveryFee == 0,
          ),
          const SizedBox(height: AppSizes.sm),
          const Divider(height: 1, thickness: 0.8, color: AppColors.divider),
          const SizedBox(height: AppSizes.sm),

          // Grand Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grand Total',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                order.total.inr2,
                style: AppTextStyles.h3.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: isDiscount ? AppColors.success : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
