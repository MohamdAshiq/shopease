import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../widgets/app_quantity_stepper.dart';
import '../cubits/product_detail_cubit.dart';

// Sticky bottom action bar
class ProductBottomBar extends StatelessWidget {
  const ProductBottomBar({
    super.key,
    required this.product,
    required this.isInCart,
    required this.onAddToCart,
    required this.onGoToCart,
  });

  final ProductModel product;
  final bool isInCart;
  final ValueChanged<int> onAddToCart;
  final VoidCallback onGoToCart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.screenPadding,
        AppSizes.sm + 4,
        AppSizes.screenPadding,
        AppSizes.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 0.8),
        ),
      ),
      child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          final cubit = context.read<ProductDetailCubit>();
          final totalPrice = product.price * state.quantity;

          return Row(
            children: [
              if (isInCart) ...[
                // Go To Cart Button
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onGoToCart();
                    },
                    icon: IconsaxPlusBold.arrow_right_3,
                    label: 'Go to Cart',
                    isFullWidth: true,
                  ),
                ),
              ] else ...[
                // Quantity Selector Widget
                AppQuantityStepper(
                  quantity: state.quantity,
                  onDecrement: state.quantity > 1
                      ? cubit.decrementQuantity
                      : null,
                  onIncrement: state.quantity < product.stock
                      ? () => cubit.incrementQuantity(product.stock)
                      : null,
                ),

                const SizedBox(width: AppSizes.md),

                // Add to Cart Button
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onAddToCart(state.quantity);
                    },
                    icon: IconsaxPlusBold.bag_2,
                    label: product.isInStock
                        ? 'Add to Cart • ${totalPrice.inr}'
                        : 'Out of Stock',
                    isFullWidth: true,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
