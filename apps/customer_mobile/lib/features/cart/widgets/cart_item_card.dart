import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../widgets/app_quantity_stepper.dart';

// Each Cart Item Card
class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    this.onTap,
    this.onMaxReached,
  });

  final CartItemModel item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;
  final VoidCallback? onTap;
  final VoidCallback? onMaxReached;

  @override
  Widget build(BuildContext context) {
    final product = item.product;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border, width: 0.8),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.sm + 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Product Thumbnail
                Container(
                  width: 76,
                  height: 76,
                  padding: const EdgeInsets.all(AppSizes.xs),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBackground,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    child: AppNetworkImage(
                      imageUrl: product.imageUrl,
                      iconSize: AppSizes.iconMd,
                      indicatorSize: 18,
                    ),
                  ),
                ),

                const SizedBox(width: AppSizes.sm + 2),

                // Product Info & Stepper
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title
                          Expanded(
                            child: Text(
                              product.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.labelLarge.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          // Remove button
                          IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: AppColors.textHint,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            tooltip: 'Remove',
                            onPressed: onRemove,
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),

                      // Category & Size Badges
                      Row(
                        children: [
                          Text(
                            product.category.toUpperCase(),
                            style: AppTextStyles.labelSmall.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textHint,
                            ),
                          ),
                          if (item.selectedSize.isNotEmpty) ...[
                            const SizedBox(width: AppSizes.xs + 2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1.5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.08,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusSm,
                                ),
                              ),
                              child: Text(
                                'Size: ${item.selectedSize}',
                                style: AppTextStyles.labelSmall.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: AppSizes.xs + 2),

                      // Price and Quantity Stepper Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            item.totalPrice.inr,
                            style: AppTextStyles.priceMedium.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          // Stepper
                          AppQuantityStepper(
                            quantity: item.quantity,
                            isCompact: true,
                            onDecrement: item.quantity > 1 ? onDecrement : null,
                            onIncrement: item.quantity < product.stock
                                ? onIncrement
                                : onMaxReached,
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
      ),
    );
  }
}
