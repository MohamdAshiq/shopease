import 'package:admin_web/features/orders/cubits/admin_orders_cubit.dart';
import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import 'order_customer_card.dart';
import 'order_items_list_card.dart';
import 'order_payment_summary_card.dart';
import 'order_status_action_bar.dart';
import 'order_timeline_card.dart';

// Slide-over inspector drawer for viewing and fulfilling orders
class OrderDetailsDrawer extends StatelessWidget {
  const OrderDetailsDrawer({
    super.key,
    required this.order,
    required this.cubit,
  });

  final OrderModel order;
  final AdminOrdersCubit cubit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 460;

        return Container(
          width: constraints.maxWidth,
          height: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: isMobile
                ? null
                : const Border(
                    left: BorderSide(color: AppColors.border, width: 1.0),
                  ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.16),
                blurRadius: 32,
                offset: const Offset(-4, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drawer Header
              _buildHeader(context, isMobile),

              // Scrollable Detail Cards
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? AppSizes.md : AppSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Status & Action Bar
                      OrderStatusActionBar(order: order, cubit: cubit),
                      const SizedBox(height: AppSizes.md),

                      // Order Timeline Stepper
                      OrderTimelineCard(order: order),
                      const SizedBox(height: AppSizes.md),

                      // Items List
                      OrderItemsListCard(order: order),
                      const SizedBox(height: AppSizes.md),

                      // Customer & Shipping Address
                      OrderCustomerCard(order: order),
                      const SizedBox(height: AppSizes.md),

                      // Payment & Financial Summary
                      OrderPaymentSummaryCard(order: order),
                      const SizedBox(height: AppSizes.xl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? AppSizes.md : AppSizes.xl,
        vertical: isMobile ? AppSizes.md : AppSizes.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1.0),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: const Icon(
              IconsaxPlusLinear.receipt_2,
              color: AppColors.primary,
              size: AppSizes.iconMd,
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.id,
                  style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  'Placed on ${order.createdAt.formattedFullDateTime}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              IconsaxPlusLinear.close_circle,
              color: AppColors.textSecondary,
            ),
            tooltip: 'Close Drawer',
            onPressed: cubit.closeDetailsDrawer,
          ),
        ],
      ),
    );
  }
}
