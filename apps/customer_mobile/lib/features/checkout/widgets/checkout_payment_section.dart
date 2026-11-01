import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../widgets/section_card_header.dart';

// Payment Method Selection in Checkout Screen
class CheckoutPaymentSection extends StatelessWidget {
  const CheckoutPaymentSection({
    super.key,
    required this.selectedMethod,
    required this.onSelectMethod,
  });

  final PaymentMethodType selectedMethod;
  final ValueChanged<PaymentMethodType> onSelectMethod;

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
          // Section Header
          const SectionCardHeader(
            icon: IconsaxPlusBold.wallet_3,
            title: 'Payment Method',
          ),

          // Payment Options List
          ...PaymentMethodModel.supportedMethods.map((method) {
            final isSelected = method.type == selectedMethod;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.sm + 2),
              child: InkWell(
                onTap: () => onSelectMethod(method.type),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.md + 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.05)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 1.5 : 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        method.icon,
                        size: 22,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSizes.md),
                      Expanded(
                        child: Text(
                          method.title,
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Icon(
                        isSelected
                            ? IconsaxPlusBold.tick_circle
                            : Icons.radio_button_off,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
