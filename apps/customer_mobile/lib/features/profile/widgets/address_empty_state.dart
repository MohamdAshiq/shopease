import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Empty State for Addresses screen
class AddressEmptyState extends StatelessWidget {
  const AddressEmptyState({super.key, required this.onAddAddress});

  final VoidCallback onAddAddress;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              IconsaxPlusLinear.location,
              size: AppSizes.iconXl,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            'No Addresses Saved',
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            'Add a delivery location for faster checkouts.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          AppButton(
            onPressed: onAddAddress,
            label: 'Add New Address',
            icon: IconsaxPlusBold.add,
          ),
        ],
      ),
    );
  }
}
