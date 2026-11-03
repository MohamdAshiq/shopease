import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../cart/cubits/cart_state.dart';

// Checkout Bill Card in Checkout Screen
class CheckoutBillCard extends StatelessWidget {
  const CheckoutBillCard({super.key, required this.cartState});

  final CartState cartState;

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
          // Header
          const SectionCardHeader(
            icon: IconsaxPlusBold.receipt_2,
            title: 'Price Details',
          ),

          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price (${cartState.totalItemCount} items)',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                cartState.subtotal.inr,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm + 2),

          // Savings
          if (cartState.totalSavings > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discount Savings',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '- ${cartState.totalSavings.inr}',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm + 2),
          ],

          // Delivery Charges
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Charges',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              cartState.isFreeDelivery
                  ? Row(
                      children: [
                        Text(
                          CartState.standardDeliveryFee.inr,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: AppSizes.xs),
                        Text(
                          'FREE',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      cartState.deliveryFee.inr,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.sm + 2),
            child: Divider(height: 1, color: AppColors.divider),
          ),

          // Total Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Payable',
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                cartState.total.inr,
                style: AppTextStyles.priceMedium.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.md),

          // Safe & Secure checkout trust banner
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  IconsaxPlusBold.shield_tick,
                  size: AppSizes.iconSm,
                  color: AppColors.success,
                ),
                const SizedBox(width: AppSizes.xs + 2),
                Text(
                  '100% Safe and Secure Checkout',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
