import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_top_bar.dart';
import '../../cart/cubits/cart_cubit.dart';
import '../../orders/cubits/order_cubit.dart';
import '../../profile/cubits/profile_cubit.dart';
import '../cubits/checkout_cubit.dart';
import '../cubits/checkout_state.dart';
import '../widgets/address_selection_sheet.dart';
import '../widgets/checkout_address_card.dart';
import '../widgets/checkout_bill_card.dart';
import '../widgets/checkout_items_summary.dart';
import '../widgets/checkout_payment_section.dart';

// Checkout Screen
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultAddress = context.read<ProfileCubit>().state.defaultAddress;
    return BlocProvider(
      create: (context) => CheckoutCubit(initialAddress: defaultAddress),
      child: const _CheckoutView(),
    );
  }
}

class _CheckoutView extends StatelessWidget {
  const _CheckoutView();

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartCubit>().state;

    return BlocConsumer<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackBar.showError(context, state.errorMessage!);
        } else if (state.isSuccess && state.placedOrder != null) {
          HapticFeedback.mediumImpact();
          context.go(RoutePaths.orderSuccess, extra: state.placedOrder);
        }
      },
      builder: (context, state) {
        final checkoutCubit = context.read<CheckoutCubit>();

        return Scaffold(
          appBar: const AppTopBar(title: 'Checkout'),
          body: cartState.isEmpty && !state.isSuccess
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        IconsaxPlusLinear.shopping_cart,
                        size: 56,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: AppSizes.md),
                      Text('Your cart is empty', style: AppTextStyles.h3),
                      const SizedBox(height: AppSizes.md),
                      AppButton(
                        onPressed: () => context.go(RoutePaths.home),
                        label: 'Start Shopping',
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.screenPadding,
                    AppSizes.md,
                    AppSizes.screenPadding,
                    AppSizes.xl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shipping Address
                      CheckoutAddressCard(
                        address: state.address,
                        onChangeAddress: () async {
                          HapticFeedback.lightImpact();
                          final selected = await AddressSelectionSheet.show(
                            context,
                            selectedAddress: state.address,
                          );
                          if (selected != null) {
                            checkoutCubit.updateAddress(selected);
                          }
                        },
                      ),
                      const SizedBox(height: AppSizes.md),

                      // Order Items Summary
                      CheckoutItemsSummary(items: cartState.items),
                      const SizedBox(height: AppSizes.md),

                      // Payment Method Selector
                      CheckoutPaymentSection(
                        selectedMethod: state.paymentMethod,
                        onSelectMethod: checkoutCubit.selectPaymentMethod,
                      ),
                      const SizedBox(height: AppSizes.md),

                      // Price & Bill Details
                      CheckoutBillCard(cartState: cartState),
                      const SizedBox(height: AppSizes.lg),
                    ],
                  ),
                ),
          bottomNavigationBar: cartState.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.screenPadding,
                    AppSizes.md,
                    AppSizes.screenPadding,
                    AppSizes.md,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    border: Border(
                      top: BorderSide(color: AppColors.border, width: 0.8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 10,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        // Total Price Column
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Amount',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              cartState.total.inr,
                              style: AppTextStyles.priceMedium.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: AppSizes.lg),

                        // Place Order Button
                        Expanded(
                          child: AppButton(
                            isLoading: state.isSubmitting,
                            onPressed: () {
                              checkoutCubit.placeOrder(
                                orderCubit: context.read<OrderCubit>(),
                                cartCubit: context.read<CartCubit>(),
                              );
                            },
                            label: 'Place Order',
                            icon: IconsaxPlusBold.tick_circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}
