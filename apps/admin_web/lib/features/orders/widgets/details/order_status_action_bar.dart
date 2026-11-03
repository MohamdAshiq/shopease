import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../cubits/admin_orders_cubit.dart';

// Status banner and action controls for order details drawer
class OrderStatusActionBar extends StatelessWidget {
  const OrderStatusActionBar({
    super.key,
    required this.order,
    required this.cubit,
  });

  final OrderModel order;
  final AdminOrdersCubit cubit;

  @override
  Widget build(BuildContext context) {
    final status = order.orderStatus;
    final nextStatus = status.nextStatus;

    final canCancel =
        status == OrderStatus.pending || status == OrderStatus.processing;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: status.statusColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: status.statusColor.withValues(alpha: 0.25),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fulfillment Status',
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              OrderStatusBadge(status: status),
            ],
          ),
          if (nextStatus != null || canCancel) ...[
            const SizedBox(height: AppSizes.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (nextStatus != null)
                  AppButton.compact(
                    isFullWidth: true,
                    label: 'Mark as ${nextStatus.displayName}',
                    icon: _getNextStatusIcon(nextStatus),
                    onPressed: () {
                      cubit.updateOrderStatus(order.id, nextStatus);
                      AppSnackBar.show(
                        context,
                        message:
                            'Order ${order.id} updated to ${nextStatus.displayName}',
                        backgroundColor: nextStatus.statusColor,
                      );
                    },
                  ),
                if (canCancel) ...[
                  if (nextStatus != null) const SizedBox(height: AppSizes.sm),
                  AppButton.compact(
                    isFullWidth: true,
                    label: 'Cancel Order',
                    icon: IconsaxPlusLinear.close_circle,
                    isOutlined: true,
                    isDestructive: true,
                    onPressed: () => _showCancelDialog(context),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  IconData _getNextStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return IconsaxPlusLinear.box_1;
      case OrderStatus.shipped:
        return IconsaxPlusLinear.truck_fast;
      case OrderStatus.delivered:
        return IconsaxPlusLinear.tick_circle;
      default:
        return IconsaxPlusLinear.arrow_right_3;
    }
  }

  void _showCancelDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        title: Row(
          children: [
            const Icon(
              IconsaxPlusLinear.danger,
              color: AppColors.error,
              size: AppSizes.iconMd,
            ),
            const SizedBox(width: AppSizes.sm),
            Text('Cancel Order', style: AppTextStyles.h3),
          ],
        ),
        content: Text(
          'Are you sure you want to cancel order ${order.id}? This will notify the customer and stop fulfillment.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          AppButton.compact(
            label: 'Keep Order',
            isOutlined: true,
            onPressed: () => Navigator.of(dialogCtx).pop(),
          ),
          AppButton.compact(
            label: 'Confirm Cancellation',
            icon: IconsaxPlusLinear.close_circle,
            onPressed: () {
              cubit.updateOrderStatus(
                order.id,
                OrderStatus.cancelled,
                note: 'Order cancelled by store administrator',
              );
              Navigator.of(dialogCtx).pop();
              AppSnackBar.showError(context, 'Order cancelled successfully');
            },
          ),
        ],
      ),
    );
  }
}
