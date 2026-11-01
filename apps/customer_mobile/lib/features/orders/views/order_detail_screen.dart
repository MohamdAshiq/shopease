import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_top_bar.dart';
import '../cubits/order_cubit.dart';
import '../cubits/order_state.dart';
import '../widgets/cancel_order_dialog.dart';
import '../widgets/order_address_card.dart';
import '../widgets/order_header_card.dart';
import '../widgets/order_items_card.dart';
import '../widgets/order_payment_card.dart';
import '../widgets/order_timeline.dart';

// Order Detail Screen
class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({
    super.key,
    required this.orderId,
    this.initialOrder,
  });

  final String orderId;
  final OrderModel? initialOrder;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(RoutePaths.home);
        }
      },
      child: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          final order = state.findById(orderId) ?? initialOrder;
          final orderCubit = context.read<OrderCubit>();

          if (order == null) {
            return Scaffold(
              appBar: const AppTopBar(title: 'Order Details'),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      IconsaxPlusLinear.box_search,
                      size: 56,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: AppSizes.md),
                    Text('Order not found', style: AppTextStyles.h3),
                    const SizedBox(height: AppSizes.md),
                    AppButton(
                      onPressed: () => context.go(RoutePaths.home),
                      label: 'Return to Home',
                    ),
                  ],
                ),
              ),
            );
          }

          final canCancel =
              order.orderStatus == OrderStatus.pending ||
              order.orderStatus == OrderStatus.processing;

          return Scaffold(
            appBar: const AppTopBar(title: 'Order Details'),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.screenPadding,
                AppSizes.md,
                AppSizes.screenPadding,
                AppSizes.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order ID & Status Pill
                  OrderHeaderCard(order: order),
                  const SizedBox(height: AppSizes.md),

                  // Tracking Stepper Timeline
                  OrderTimeline(order: order),
                  const SizedBox(height: AppSizes.md),

                  // Ordered Items
                  OrderItemsCard(order: order),
                  const SizedBox(height: AppSizes.md),

                  // Shipping Destination
                  OrderAddressCard(order: order),
                  const SizedBox(height: AppSizes.md),

                  // Billing Breakdown
                  OrderPaymentCard(order: order),
                  const SizedBox(height: AppSizes.lg),

                  // Cancel Order Action
                  if (canCancel) ...[
                    AppButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        CancelOrderDialog.show(
                          context,
                          onConfirmCancel: () {
                            orderCubit.cancelOrder(orderId);
                            AppSnackBar.show(
                              context,
                              message: 'Order #$orderId has been cancelled',
                            );
                          },
                        );
                      },
                      label: 'Cancel Order',
                      isOutlined: true,
                      isDestructive: true,
                      icon: IconsaxPlusLinear.close_circle,
                      isFullWidth: true,
                    ),
                    const SizedBox(height: AppSizes.md),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
