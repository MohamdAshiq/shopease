import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Item Summary in Checkout Screen
class CheckoutItemsSummary extends StatefulWidget {
  const CheckoutItemsSummary({super.key, required this.items});

  final List<CartItemModel> items;

  @override
  State<CheckoutItemsSummary> createState() => _CheckoutItemsSummaryState();
}

class _CheckoutItemsSummaryState extends State<CheckoutItemsSummary> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        children: [
          // Header toggle
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: SectionCardHeader(
                icon: IconsaxPlusBold.bag_2,
                title: 'Items Summary (${widget.items.length})',
                showDivider: false,
                trailing: Icon(
                  _isExpanded
                      ? IconsaxPlusLinear.arrow_up_1
                      : IconsaxPlusLinear.arrow_down,
                  size: AppSizes.iconSm,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),

          if (_isExpanded) ...[
            const Divider(height: 1, color: AppColors.divider),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSizes.md),
              itemCount: widget.items.length,
              separatorBuilder: (_, _) => const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.sm + 2),
                child: Divider(height: 1, color: AppColors.divider),
              ),
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Product image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: AppNetworkImage(imageUrl: item.product.imageUrl),
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm + 4),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              if (item.selectedSize.isNotEmpty) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.divider.withValues(
                                      alpha: 0.6,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.xs,
                                    ),
                                  ),
                                  child: Text(
                                    'Size: ${item.selectedSize}',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSizes.xs + 2),
                              ],
                              Text(
                                'Qty: ${item.quantity}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Price
                    Text(
                      item.totalPrice.inr,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
