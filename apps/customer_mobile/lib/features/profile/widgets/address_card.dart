import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import 'delete_address_dialog.dart';

// Delivery Address Card
class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    required this.address,
    required this.isDefault,
    required this.onSetDefault,
    required this.onEdit,
    required this.onDelete,
  });

  final CustomerAddressModel address;
  final bool isDefault;
  final VoidCallback onSetDefault;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final tagLabel = address.label?.isNotEmpty == true
        ? address.label!
        : 'Home';
    final tagIcon = address.tagIcon;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: isDefault
              ? AppColors.primary
              : AppColors.divider.withValues(alpha: 0.8),
          width: isDefault ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDefault ? 0.05 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: InkWell(
          onTap: () {
            if (!isDefault) {
              HapticFeedback.lightImpact();
              onSetDefault();
            }
          },
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          splashColor: AppColors.primary.withValues(alpha: 0.05),
          highlightColor: AppColors.primary.withValues(alpha: 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.md,
                  AppSizes.md,
                  AppSizes.md,
                  AppSizes.sm + 2,
                ),
                child: Row(
                  children: [
                    // Radio button indicator
                    Icon(
                      isDefault
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      size: AppSizes.iconSm + AppSizes.xs,
                      color: isDefault ? AppColors.primary : AppColors.textHint,
                    ),
                    const SizedBox(width: AppSizes.sm + 2),

                    // Recipient Name & Tag Chip
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
                          const SizedBox(width: AppSizes.sm),

                          // Tag badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.sm,
                              vertical: AppSizes.xs,
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

                    // Default badge
                    if (isDefault) ...[
                      const SizedBox(width: AppSizes.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.sm,
                          vertical: AppSizes.xs,
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
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Address content
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.md +
                      (AppSizes.iconSm + AppSizes.xs) +
                      (AppSizes.sm + 2),
                  0,
                  AppSizes.md,
                  AppSizes.md,
                ),
                child: Text(
                  address.formattedAddress,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),

              const Divider(height: 1, color: AppColors.divider),

              // Footer Section
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.md,
                  AppSizes.xs + 2,
                  AppSizes.xs,
                  AppSizes.xs + 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Phone number
                    if (address.phone?.isNotEmpty == true)
                      Row(
                        children: [
                          const Icon(
                            IconsaxPlusLinear.call,
                            size: AppSizes.iconSm - 2,
                            color: AppColors.textHint,
                          ),
                          const SizedBox(width: AppSizes.sm),
                          Text(
                            address.phone!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    else
                      const SizedBox.shrink(),

                    // Actions: Edit and Delete
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            onEdit();
                          },
                          icon: const Icon(
                            IconsaxPlusLinear.edit,
                            size: AppSizes.iconSm,
                            color: AppColors.textSecondary,
                          ),
                          tooltip: 'Edit Address',
                          visualDensity: VisualDensity.compact,
                        ),
                        IconButton(
                          onPressed: () => DeleteAddressDialog.show(
                            context,
                            onConfirmDelete: onDelete,
                          ),
                          icon: const Icon(
                            IconsaxPlusLinear.trash,
                            size: AppSizes.iconSm,
                            color: AppColors.error,
                          ),
                          tooltip: 'Delete Address',
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
