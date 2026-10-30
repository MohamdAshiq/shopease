import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';
import '../../home/widgets/product_card_vertical.dart';

// Search Result Grid
class SearchResultsGrid extends StatelessWidget {
  const SearchResultsGrid({
    super.key,
    required this.products,
    required this.query,
    this.onProductTap,
  });

  final List<ProductModel> products;
  final String query;
  final VoidCallback? onProductTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.screenPadding,
            AppSizes.md,
            AppSizes.screenPadding,
            AppSizes.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Results for "$query"',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                '${products.length} found',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                  onProductTap?.call();
                  context.pushNamed(
                    RouteNames.productDetail,
                    pathParameters: {'id': product.id},
                    extra: product,
                  );
                },
                onAddToCart: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}
