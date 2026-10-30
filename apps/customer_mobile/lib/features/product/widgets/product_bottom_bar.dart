import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../widgets/app_button.dart';
import '../cubits/product_detail_cubit.dart';

// Sticky bottom action bar
class ProductBottomBar extends StatelessWidget {
  const ProductBottomBar({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  final ProductModel product;
  final ValueChanged<int> onAddToCart;

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
              // Quantity Selector Widget
              Container(
                height: AppSizes.buttonHeight,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _StepperButton(
                      icon: IconsaxPlusLinear.minus,
                      onTap: state.quantity > 1
                          ? cubit.decrementQuantity
                          : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm + 2,
                      ),
                      child: Text(
                        '${state.quantity}',
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _StepperButton(
                      icon: IconsaxPlusLinear.add,
                      onTap: state.quantity < product.stock
                          ? () => cubit.incrementQuantity(product.stock)
                          : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSizes.md),

              // Add to Cart Button
              Expanded(
                child: AppButton(
                  onPressed: product.isInStock
                      ? () => onAddToCart(state.quantity)
                      : null,
                  icon: IconsaxPlusBold.bag_2,
                  label: product.isInStock
                      ? 'Add to Cart • ${totalPrice.inr}'
                      : 'Out of Stock',
                  isFullWidth: true,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xs + 2),
        child: Icon(
          icon,
          size: 16,
          color: isEnabled ? AppColors.textPrimary : AppColors.textHint,
        ),
      ),
    );
  }
}
