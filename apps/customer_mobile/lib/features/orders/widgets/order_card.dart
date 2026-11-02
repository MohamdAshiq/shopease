import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';
import 'order_status_badge.dart';

// Order summary card displayed in My Orders screen
class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final status = order.orderStatus;

    // Preview items (up to 2 pictures, 3rd card shows remaining count)
    final previewItems = order.items.take(2).toList();
    final remainingCount = order.items.length - previewItems.length;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.6)),
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
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            context.push(RoutePaths.orderDetailOf(order.id), extra: order);
          },
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          splashColor: AppColors.primary.withValues(alpha: 0.05),
          highlightColor: AppColors.primary.withValues(alpha: 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Order ID, Date & Status
              Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.id,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSizes.xs / 2),
                          if (order.createdAt != null)
                            Text(
                              order.createdAt!.formattedDate,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    OrderStatusBadge(status: status, showDot: true),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.divider),

              // Items summary & thumbnails
              Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Row(
                  children: [
                    // Thumbnails row
                    Row(
                      children: [
                        for (int i = 0; i < previewItems.length; i++) ...[
                          Container(
                            width: AppSizes.itemThumbnailSize,
                            height: AppSizes.itemThumbnailSize,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusSm,
                              ),
                              border: Border.all(color: AppColors.divider),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: AppNetworkImage(
                              imageUrl: previewItems[i].imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          if (i < previewItems.length - 1)
                            const SizedBox(width: AppSizes.xs + 2),
                        ],
                        if (remainingCount > 0) ...[
                          const SizedBox(width: AppSizes.xs + 2),
                          Container(
                            width: AppSizes.itemThumbnailSize,
                            height: AppSizes.itemThumbnailSize,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusSm,
                              ),
                              border: Border.all(color: AppColors.divider),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '+$remainingCount',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(width: AppSizes.md),

                    // Item description & quantity
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.items.isNotEmpty
                                ? order.items.first.title
                                : 'Order items',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSizes.xs),
                          Text(
                            '${order.totalItemCount} item${order.totalItemCount > 1 ? 's' : ''}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.divider),

              // Footer Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: AppSizes.radiusMd,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total (${order.totalItemCount} item${order.totalItemCount > 1 ? 's' : ''})',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      order.total.inr,
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
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
