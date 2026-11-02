import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../dashboard/constants/dashboard_constants.dart';
import '../../../dashboard/widgets/components/order_status_badge.dart';
import '../../cubits/admin_orders_cubit.dart';

// Orders Table Row Builder
abstract final class OrderTableRowBuilder {
  static TableRow buildHeader() {
    return const TableRow(
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1.0),
        ),
      ),
      children: [
        _OrderHeaderCell('ORDER'),
        _OrderHeaderCell('CUSTOMER'),
        _OrderHeaderCell('ITEMS'),
        _OrderHeaderCell('TOTAL'),
        _OrderHeaderCell('PAYMENT'),
        _OrderHeaderCell('STATUS'),
        _OrderHeaderCell('ACTIONS', alignRight: true),
      ],
    );
  }

  static TableRow buildRow({
    required BuildContext context,
    required OrderModel order,
    required AdminOrdersCubit cubit,
    required bool isSelected,
    required bool isEven,
  }) {
    final bgColor = isSelected
        ? AppColors.primary.withValues(alpha: 0.06)
        : isEven
        ? AppColors.surface
        : AppColors.scaffoldBackground.withValues(alpha: 0.5);

    return TableRow(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          bottom: const BorderSide(color: AppColors.divider, width: 0.8),
          left: isSelected
              ? const BorderSide(color: AppColors.primary, width: 3.0)
              : BorderSide.none,
        ),
      ),
      children: [
        _OrderIdCell(order: order, onSelect: () => cubit.selectOrder(order.id)),
        _OrderCustomerCell(order: order),
        _OrderItemsPreviewCell(order: order),
        _OrderTotalCell(order: order),
        _OrderPaymentCell(order: order),
        _OrderStatusCell(order: order),
        _OrderActionsCell(order: order, cubit: cubit),
      ],
    );
  }
}

class _OrderHeaderCell extends StatelessWidget {
  const _OrderHeaderCell(this.label, {this.alignRight = false});

  final String label;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.md,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          label,
          textAlign: alignRight ? TextAlign.right : TextAlign.left,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

class _OrderIdCell extends StatelessWidget {
  const _OrderIdCell({required this.order, required this.onSelect});

  final OrderModel order;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    order.id,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSizes.xs),
                  IconButton(
                    icon: const Icon(
                      IconsaxPlusLinear.copy,
                      size: AppSizes.iconSm - 4,
                      color: AppColors.textSecondary,
                    ),
                    tooltip: 'Copy ID',
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: order.id));
                      AppSnackBar.show(
                        context,
                        message: 'Order ${order.id} copied to clipboard',
                        duration: const Duration(seconds: 1),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.xxs),
            Text(
              order.createdAt.formattedShortDateTime,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCustomerCell extends StatelessWidget {
  const _OrderCustomerCell({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            order.customerName,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSizes.xxs),
          Text(
            order.customerEmail,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _OrderItemsPreviewCell extends StatelessWidget {
  const _OrderItemsPreviewCell({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final extraCount = order.items.length - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.md,
      ),
      child: Row(
        children: [
          Container(
            width: DashboardConstants.productThumbnailSize,
            height: DashboardConstants.productThumbnailSize,
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              border: Border.all(color: AppColors.border, width: 0.8),
            ),
            clipBehavior: Clip.antiAlias,
            child: firstItem?.imageUrl != null && firstItem!.imageUrl.isNotEmpty
                ? Image.network(
                    firstItem.imageUrl,
                    cacheWidth: 80,
                    cacheHeight: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      IconsaxPlusLinear.box,
                      color: AppColors.textSecondary,
                      size: AppSizes.iconSm,
                    ),
                  )
                : const Icon(
                    IconsaxPlusLinear.box,
                    color: AppColors.textSecondary,
                    size: AppSizes.iconSm,
                  ),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  firstItem?.title ?? 'No items',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (extraCount > 0) ...[
                  const SizedBox(height: AppSizes.xxs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.xs + 2,
                      vertical: AppSizes.xxs / 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                    child: Text(
                      '+$extraCount more',
                      style: AppTextStyles.badge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderTotalCell extends StatelessWidget {
  const _OrderTotalCell({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.md,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            order.total.inr2,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderPaymentCell extends StatelessWidget {
  const _OrderPaymentCell({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final method = order.paymentMethod;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.md,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              method.linearIcon,
              size: AppSizes.iconSm - 2,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSizes.xs),
            Text(
              method.shortLabel,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderStatusCell extends StatelessWidget {
  const _OrderStatusCell({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.md,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: OrderStatusBadge(status: order.orderStatus, compact: true),
        ),
      ),
    );
  }
}

class _OrderActionsCell extends StatelessWidget {
  const _OrderActionsCell({required this.order, required this.cubit});

  final OrderModel order;
  final AdminOrdersCubit cubit;

  @override
  Widget build(BuildContext context) {
    final nextStatus = order.orderStatus.nextStatus;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.md,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Next Status Quick Button
            if (nextStatus != null)
              IconButton(
                icon: Icon(
                  _getNextStatusIcon(nextStatus),
                  color: nextStatus.statusColor,
                  size: AppSizes.iconSm,
                ),
                tooltip: 'Advance to ${nextStatus.displayName}',
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  cubit.updateOrderStatus(order.id, nextStatus);
                  AppSnackBar.show(
                    context,
                    message:
                        'Order ${order.id} marked as ${nextStatus.displayName}',
                    backgroundColor: nextStatus.statusColor,
                    duration: const Duration(seconds: 2),
                  );
                },
              ),

            // Inspect / Details Button
            IconButton(
              icon: const Icon(
                IconsaxPlusLinear.eye,
                color: AppColors.textSecondary,
                size: AppSizes.iconSm,
              ),
              tooltip: 'View Order Details',
              visualDensity: VisualDensity.compact,
              onPressed: () => cubit.selectOrder(order.id),
            ),
          ],
        ),
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
}
