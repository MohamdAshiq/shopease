import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';
import '../../../widgets/app_button.dart';

// Order Success Screen
class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final formattedEstDate = DateTime.now()
        .add(const Duration(days: 4))
        .formattedDate;

    final isCod = order.paymentMethod == PaymentMethodType.cod;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(RoutePaths.home);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPadding,
            ),
            child: Column(
              children: [
                const Spacer(),

                // Success Lottie Animation
                SizedBox(
                  width: 140,
                  height: 140,
                  child: Lottie.asset(
                    'assets/lottie/success_animation.json',
                    package: 'shopease_core',
                    repeat: true,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: AppSizes.md),

                // Success Title & Subtitle
                Text(
                  'Order Placed Successfully!',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  'Your order has been confirmed and will be shipped shortly.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSizes.lg),

                // Order Details Summary Card
                Container(
                  padding: const EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    border: Border.all(color: AppColors.border, width: 0.8),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    spacing: AppSizes.xs,
                    children: [
                      // Order ID with Copy action
                      _SuccessInfoRow(
                        label: 'Order ID',
                        valueWidget: InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: order.id));
                            AppSnackBar.show(
                              context,
                              message: 'Order ID copied to clipboard',
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                order.id,
                                style: AppTextStyles.labelMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                IconsaxPlusLinear.copy,
                                size: 13,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSizes.sm + 2,
                        ),
                        child: Divider(height: 1, color: AppColors.divider),
                      ),

                      // Estimated Delivery
                      _SuccessInfoRow(
                        label: 'Estimated Delivery',
                        value: formattedEstDate,
                      ),
                      const SizedBox(height: AppSizes.sm + 2),

                      // Delivery Address preview
                      _SuccessInfoRow(
                        label: 'Delivering to',
                        value:
                            order.deliveryAddress.recipientName?.isNotEmpty ==
                                true
                            ? '${order.deliveryAddress.recipientName}, ${order.deliveryAddress.city}'
                            : order.deliveryAddress.city,
                      ),
                      const SizedBox(height: AppSizes.sm + 2),

                      // Total Amount
                      _SuccessInfoRow(
                        label: isCod
                            ? 'To Pay on Delivery (${order.totalItemCount} items)'
                            : 'Total Paid (${order.totalItemCount} items)',
                        value: order.total.inr,
                        valueStyle: AppTextStyles.priceMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Action Buttons
                AppButton(
                  onPressed: () {
                    context.go(
                      RoutePaths.orderDetailOf(order.id),
                      extra: order,
                    );
                  },
                  label: 'Track Order',
                  icon: IconsaxPlusBold.routing,
                  isFullWidth: true,
                ),
                const SizedBox(height: AppSizes.sm),

                AppButton(
                  onPressed: () => context.go(RoutePaths.home),
                  label: 'Continue Shopping',
                  isOutlined: true,
                  isFullWidth: true,
                ),
                const SizedBox(height: AppSizes.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Each row in the order summary card
class _SuccessInfoRow extends StatelessWidget {
  const _SuccessInfoRow({
    required this.label,
    this.value,
    this.valueWidget,
    this.valueStyle,
  }) : assert(value != null || valueWidget != null);

  final String label;
  final String? value;
  final Widget? valueWidget;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        Flexible(
          child:
              valueWidget ??
              Text(
                value!,
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    valueStyle ??
                    AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
              ),
        ),
      ],
    );
  }
}
