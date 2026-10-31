import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

// Address Selection Tile
class AddressSelectionTile extends StatelessWidget {
  const AddressSelectionTile({
    super.key,
    required this.address,
    required this.isSelected,
    required this.isDefault,
    required this.onTap,
    required this.onEdit,
  });

  final CustomerAddressModel address;
  final bool isSelected;
  final bool isDefault;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final tagLabel = address.label?.isNotEmpty == true
        ? address.label!
        : 'Home';
    final tagIcon = address.tagIcon;

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.04)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : AppColors.divider.withValues(alpha: 0.8),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          splashColor: AppColors.primary.withValues(alpha: 0.05),
          highlightColor: AppColors.primary.withValues(alpha: 0.02),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      size: AppSizes.iconSm + AppSizes.xs,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textHint,
                    ),
                    const SizedBox(width: AppSizes.sm + 2),

                    // Name & Tag
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              address.recipientName?.isNotEmpty == true
                                  ? address.recipientName!
                                  : 'Alex Morgan',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppSizes.xs + 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.sm - 2,
                              vertical: AppSizes.xs / 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(AppSizes.xs),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  tagIcon,
                                  size: AppSizes.radiusMd,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: AppSizes.xs),
                                Text(
                                  tagLabel,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Default badge and Edit Button
                    if (isDefault) ...[
                      const SizedBox(width: AppSizes.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.sm - 2,
                          vertical: AppSizes.xs / 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppSizes.xs),
                        ),
                        child: Text(
                          'DEFAULT',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(width: AppSizes.xs),
                    InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onEdit();
                      },
                      borderRadius: BorderRadius.circular(AppSizes.xs),
                      child: const Padding(
                        padding: EdgeInsets.all(AppSizes.xs),
                        child: Icon(
                          IconsaxPlusLinear.edit,
                          size: AppSizes.iconSm,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.xs + 2),

                // Address text
                Padding(
                  padding: const EdgeInsets.only(
                    left: (AppSizes.iconSm + AppSizes.xs) + AppSizes.sm,
                  ),
                  child: Text(
                    address.formattedAddress,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ),

                // Phone
                if (address.phone?.isNotEmpty == true) ...[
                  const SizedBox(height: AppSizes.xs),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: (AppSizes.iconSm + AppSizes.xs) + AppSizes.sm,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          IconsaxPlusLinear.call,
                          size: AppSizes.radiusMd,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(width: AppSizes.xs),
                        Text(
                          address.phone!,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
