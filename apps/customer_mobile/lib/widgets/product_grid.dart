import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import 'product_card_vertical.dart';

// 2-column Product Grid
class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    this.shrinkWrap = false,
    this.physics,
    this.padding = const EdgeInsets.fromLTRB(
      AppSizes.screenPadding,
      AppSizes.xs,
      AppSizes.screenPadding,
      AppSizes.xxl,
    ),
    this.onProductTap,
    this.onAddToCart,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  });

  final List<ProductModel> products;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry padding;
  final ValueChanged<ProductModel>? onProductTap;
  final ValueChanged<ProductModel>? onAddToCart;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      keyboardDismissBehavior: keyboardDismissBehavior,
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSizes.sm + 4,
        mainAxisSpacing: AppSizes.md,
        childAspectRatio: 0.73,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCardVertical(
          product: product,
          onTap: onProductTap != null ? () => onProductTap!(product) : null,
          onAddToCart: onAddToCart != null ? () => onAddToCart!(product) : null,
        );
      },
    );
  }
}
