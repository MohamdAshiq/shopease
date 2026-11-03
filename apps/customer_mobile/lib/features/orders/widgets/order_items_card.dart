import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Items Card in Order Detail Screen
class OrderItemsCard extends StatelessWidget {
  const OrderItemsCard({super.key, required this.order});

  final OrderModel order;

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
            icon: IconsaxPlusBold.bag_2,
            title: 'Items in this Order (${order.totalItemCount})',
          ),
          for (int index = 0; index < order.items.length; index++) ...[
            if (index > 0)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.sm + 2),
                child: Divider(height: 1, color: AppColors.divider),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  child: SizedBox(
                    width: AppSizes.itemThumbnailSize,
                    height: AppSizes.itemThumbnailSize,
                    child: AppNetworkImage(
                      imageUrl: order.items[index].imageUrl,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.sm + 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.items[index].title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        'Qty: ${order.items[index].quantity}  •  ${order.items[index].price.inr}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Text(
                  order.items[index].totalPrice.inr,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
