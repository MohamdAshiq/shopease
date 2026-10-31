import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';
import '../cubits/cart_cubit.dart';
import '../cubits/cart_state.dart';
import '../widgets/cart_app_bar.dart';
import '../widgets/cart_bottom_bar.dart';
import '../widgets/cart_empty_state.dart';
import '../widgets/cart_item_card.dart';

// Cart Screen
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cubit = context.read<CartCubit>();

        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: CartAppBar(
            itemCount: state.totalItemCount,
            onClear: cubit.clearCart,
          ),
          body: state.isEmpty
              ? const CartEmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.screenPadding,
                    AppSizes.sm,
                    AppSizes.screenPadding,
                    AppSizes.lg,
                  ),
                  itemCount: state.items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSizes.sm + 2),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return CartItemCard(
                      item: item,
                      onTap: () => context.pushNamed(
                        RouteNames.productDetail,
                        pathParameters: {'id': item.product.id},
                        queryParameters: item.selectedSize.isNotEmpty
                            ? {'size': item.selectedSize}
                            : const {},
                        extra: item.product,
                      ),
                      onIncrement: () {
                        HapticFeedback.lightImpact();
                        cubit.incrementQuantity(
                          item.product.id,
                          item.selectedSize,
                        );
                      },
                      onDecrement: () {
                        HapticFeedback.lightImpact();
                        cubit.decrementQuantity(
                          item.product.id,
                          item.selectedSize,
                        );
                      },
                      onMaxReached: () {
                        HapticFeedback.selectionClick();
                        AppSnackBar.showError(
                          context,
                          'Maximum available stock (${item.product.stock}) already in cart',
                        );
                      },
                      onRemove: () {
                        final removedItem = item;
                        final removedIndex = index;
                        HapticFeedback.mediumImpact();
                        cubit.removeFromCart(
                          item.product.id,
                          item.selectedSize,
                        );
                        AppSnackBar.show(
                          context,
                          message:
                              'Removed "${removedItem.product.title}" from cart',
                          actionLabel: 'UNDO',
                          onAction: () {
                            HapticFeedback.lightImpact();
                            cubit.restoreItem(removedIndex, removedItem);
                          },
                        );
                      },
                    );
                  },
                ),
          bottomNavigationBar: state.isNotEmpty
              ? CartBottomBar(state: state, onCheckout: () {})
              : null,
        );
      },
    );
  }
}
