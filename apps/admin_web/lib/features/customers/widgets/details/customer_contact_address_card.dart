import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../models/customer_view_model.dart';

// Contact information and shipping address card for customer profile drawer
class CustomerContactAddressCard extends StatelessWidget {
  const CustomerContactAddressCard({super.key, required this.customer});

  final CustomerViewModel customer;

  @override
  Widget build(BuildContext context) {
    final addr = customer.address;

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
                IconsaxPlusLinear.personalcard,
                size: AppSizes.iconSm,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSizes.xs + 2),
              Text(
                'Contact & Shipping',
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),

          // Email Tile
          _buildInfoRow(
            context,
            icon: IconsaxPlusLinear.sms,
            label: 'Email Address',
            value: customer.email,
            copyText: customer.email,
          ),
          const SizedBox(height: AppSizes.sm),

          // Phone Tile
          _buildInfoRow(
            context,
            icon: IconsaxPlusLinear.call,
            label: 'Phone Number',
            value: customer.phone.isNotEmpty ? customer.phone : 'Not provided',
            copyText: customer.phone.isNotEmpty ? customer.phone : null,
          ),
          const SizedBox(height: AppSizes.md),
          const Divider(height: 1, thickness: 0.8, color: AppColors.divider),
          const SizedBox(height: AppSizes.md),

          // Primary Delivery Address
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    IconsaxPlusLinear.location,
                    size: AppSizes.iconSm,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSizes.xs + 2),
                  Text(
                    'Default Address',
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (addr?.label != null && addr!.label!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.sm,
                    vertical: AppSizes.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                  child: Text(
                    addr.label!,
                    style: AppTextStyles.badge.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.sm + 2),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              border: Border.all(color: AppColors.border, width: 0.8),
            ),
            child: addr != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (addr.street.isNotEmpty)
                        Text(
                          addr.street,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      const SizedBox(height: AppSizes.xxs),
                      Text(
                        '${addr.city}, ${addr.state} - ${addr.postalCode}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (addr.country.isNotEmpty) ...[
                        const SizedBox(height: AppSizes.xxs),
                        Text(
                          addr.country,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  )
                : Text(
                    'No shipping address on file.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    String? copyText,
  }) {
    return Row(
      children: [
        Icon(icon, size: AppSizes.iconSm - 2, color: AppColors.textSecondary),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (copyText != null && copyText.isNotEmpty)
          IconButton(
            icon: const Icon(
              IconsaxPlusLinear.copy,
              size: AppSizes.iconSm - 4,
              color: AppColors.textSecondary,
            ),
            tooltip: 'Copy $label',
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: copyText));
              AppSnackBar.show(
                context,
                message: '$value copied to clipboard',
                duration: const Duration(seconds: 1),
              );
            },
          ),
      ],
    );
  }
}
