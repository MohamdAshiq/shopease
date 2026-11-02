import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Ordered items card for details drawer
class OrderItemsListCard extends StatelessWidget {
  const OrderItemsListCard({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    IconsaxPlusLinear.box,
                    size: AppSizes.iconSm,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSizes.xs + 2),
                  Text(
                    'Order Items',
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  border: Border.all(color: AppColors.border, width: 0.8),
                ),
                child: Text(
                  '${order.totalItemCount} ${order.totalItemCount == 1 ? 'item' : 'items'}',
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (context, index) => const Divider(
              height: AppSizes.md,
              thickness: 0.8,
              color: AppColors.divider,
            ),
            itemBuilder: (context, index) {
              final item = order.items[index];
              final lineTotal = item.price * item.quantity;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Product Thumbnail
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldBackground,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      border: Border.all(color: AppColors.border, width: 0.8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: item.imageUrl.isNotEmpty
                        ? Image.network(
                            item.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  IconsaxPlusLinear.box,
                                  color: AppColors.textSecondary,
                                ),
                          )
                        : const Icon(
                            IconsaxPlusLinear.box,
                            color: AppColors.textSecondary,
                          ),
                  ),
                  const SizedBox(width: AppSizes.md),

                  // Title & Unit Price
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '₹${item.price.toStringAsFixed(2)} × ${item.quantity}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: AppSizes.sm),

                  // Line Total
                  Text(
                    '₹${lineTotal.toStringAsFixed(2)}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
