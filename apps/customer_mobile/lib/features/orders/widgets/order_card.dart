import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';

// Order summary card displayed in My Orders screen
class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final status = order.orderStatus;
    final statusColor = status.statusColor;

    // Preview items (up to 2 pictures, 3rd card shows remaining count)
    final previewItems = order.items.take(2).toList();
    final remainingCount = order.items.length - previewItems.length;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm + 2,
                        vertical: AppSizes.xs,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusFull,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: AppSizes.sm - 2,
                            height: AppSizes.sm - 2,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppSizes.xs + 2),
                          Text(
                            status.displayName,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                            width: AppSizes.inputHeight,
                            height: AppSizes.inputHeight,
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
                            width: AppSizes.inputHeight,
                            height: AppSizes.inputHeight,
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
