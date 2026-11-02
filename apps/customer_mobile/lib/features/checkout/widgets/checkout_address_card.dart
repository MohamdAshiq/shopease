import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Address Card in Checkout Screen
class CheckoutAddressCard extends StatelessWidget {
  const CheckoutAddressCard({
    super.key,
    required this.address,
    required this.onChangeAddress,
  });

  final CustomerAddressModel address;
  final VoidCallback onChangeAddress;

  bool get _hasAddress =>
      address.street.trim().isNotEmpty && address.city.trim().isNotEmpty;

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
          SectionCardHeader(
            icon: IconsaxPlusBold.location,
            title: 'Shipping Address',
            trailing: TextButton(
              onPressed: onChangeAddress,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs,
                ),
                visualDensity: VisualDensity.compact,
              ),
              child: Text(
                _hasAddress ? 'Change' : 'Add',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          if (!_hasAddress)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onChangeAddress,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.xs),
                child: Row(
                  children: [
                    const Icon(
                      IconsaxPlusLinear.location_add,
                      size: AppSizes.iconMd,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: Text(
                        'No delivery address selected. Tap to add one.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            // Recipient Info & Tag Pill
            if (address.recipientName?.isNotEmpty == true) ...[
              Row(
                children: [
                  Text(
                    address.recipientName!,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (address.label?.isNotEmpty == true) ...[
                    const SizedBox(width: AppSizes.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm - 1,
                        vertical: AppSizes.xs / 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(AppSizes.xs),
                      ),
                      child: Text(
                        address.label!,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSizes.xs + 2),
            ],

            // Formatted address line
            Text(
              address.formattedAddress,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),

            // Phone
            if (address.phone?.isNotEmpty == true) ...[
              const SizedBox(height: AppSizes.sm),
              Row(
                children: [
                  const Icon(
                    IconsaxPlusLinear.call,
                    size: AppSizes.iconSm,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSizes.xs),
                  Text(
                    address.phone!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }
}
