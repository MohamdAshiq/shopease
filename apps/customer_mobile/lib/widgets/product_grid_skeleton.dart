import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import 'product_grid.dart';

// Skeleton loader for product grid
class ProductGridSkeleton extends StatelessWidget {
  const ProductGridSkeleton({
    super.key,
    this.itemCount = 6,
    this.shrinkWrap = false,
    this.physics,
    this.padding,
  });

  final int itemCount;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      containersColor: AppColors.shimmerContainer,
      effect: const ShimmerEffect(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        duration: Duration(milliseconds: 1500),
      ),
      child: ProductGrid(
        products: List.generate(
          itemCount,
          (i) => ProductModel(
            id: 'placeholder_$i',
            title: 'Product Name',
            description: 'Product description goes here for placeholder...',
            price: 1999.0,
            stock: 10,
            category: 'Category',
            imageUrl: '',
          ),
        ),
        shrinkWrap: shrinkWrap,
        physics: physics,
        padding:
            padding ??
            const EdgeInsets.fromLTRB(
              AppSizes.screenPadding,
              AppSizes.xs,
              AppSizes.screenPadding,
              AppSizes.xxl,
            ),
      ),
    );
  }
}
