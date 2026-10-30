import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';
import '../../home/widgets/product_card_vertical.dart';

// Product grid
class StoreProductGrid extends StatelessWidget {
  const StoreProductGrid({super.key, required this.products});

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.screenPadding,
        AppSizes.xs,
        AppSizes.screenPadding,
        AppSizes.xxl,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSizes.sm + 4,
        mainAxisSpacing: AppSizes.md,
        childAspectRatio: 0.73,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCardVertical(
          product: product,
          onTap: () {
            context.pushNamed(
              RouteNames.productDetail,
              pathParameters: {'id': product.id},
              extra: product,
            );
          },
          onAddToCart: () {},
        );
      },
    );
  }
}
