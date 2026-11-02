import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../../app/routing/admin_route_constants.dart';
import '../../../dashboard/widgets/components/order_status_badge.dart';
import '../../models/customer_view_model.dart';

// Order history list for customer profile drawer
class CustomerOrdersHistoryCard extends StatelessWidget {
  const CustomerOrdersHistoryCard({super.key, required this.customer});

  final CustomerViewModel customer;

  @override
  Widget build(BuildContext context) {
    final orders = customer.orders;

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
                    IconsaxPlusLinear.receipt_2,
                    size: AppSizes.iconSm,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSizes.xs + 2),
                  Text(
                    'Order History',
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xxs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                ),
                child: Text(
                  '${orders.length} ${orders.length == 1 ? 'order' : 'orders'}',
                  style: AppTextStyles.badge.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          if (orders.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
              child: Center(
                child: Text(
                  'No orders placed yet.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: AppSizes.md, color: AppColors.divider),
              itemBuilder: (context, index) {
                final order = orders[index];
                final dateStr = order.createdAt.formattedShortDateTime;

                return InkWell(
                  onTap: () {
                    // Navigate to orders screen
                    context.go(AdminRoutePaths.orders);
                  },
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSizes.xs,
                      horizontal: AppSizes.xs,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    order.id,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.sm),
                                  OrderStatusBadge(
                                    status: order.orderStatus,
                                    compact: true,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSizes.xxs),
                              Text(
                                '$dateStr · ${order.totalItemCount} ${order.totalItemCount == 1 ? 'item' : 'items'}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          order.total.inr2,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: AppSizes.xs),
                        const Icon(
                          IconsaxPlusLinear.arrow_right_3,
                          size: AppSizes.iconSm - 2,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
