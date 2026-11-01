import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../widgets/app_button.dart';
import '../cubits/cart_state.dart';

// Bottom summary bar with price and checkout button
class CartBottomBar extends StatelessWidget {
  const CartBottomBar({
    super.key,
    required this.state,
    required this.onCheckout,
  });

  final CartState state;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.screenPadding,
        AppSizes.md,
        AppSizes.screenPadding,
        AppSizes.md,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.8)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Savings Banner
            if (state.totalSavings > 0) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.md),
                margin: EdgeInsets.only(bottom: AppSizes.xs),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      IconsaxPlusBold.discount_shape,
                      size: 16,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: AppSizes.xs + 2),
                    Text(
                      'You are saving ${state.totalSavings.inr} on this order',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.sm + 2),
            ],

            // Subtotal Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal (${state.totalItemCount} items)',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  state.subtotal.inr,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSizes.xs + 2),

            // Delivery Fee Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Delivery Fee',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (state.deliveryFee == 0.0) ...[
                      const SizedBox(width: AppSizes.xs),
                      Text(
                        '(Orders > ₹999)',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 10,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  state.deliveryFee == 0.0 ? 'FREE' : state.deliveryFee.inr,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: state.deliveryFee == 0.0
                        ? AppColors.success
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSizes.sm),
              child: Divider(
                height: 1,
                thickness: 0.6,
                color: AppColors.divider,
              ),
            ),

            // Grand Total Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  state.total.inr,
                  style: AppTextStyles.priceLarge.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSizes.md),

            // Checkout Button
            AppButton(
              onPressed: onCheckout,
              label: 'Proceed to Checkout',
              icon: IconsaxPlusLinear.arrow_right_3,
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
