import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';
import '../../../widgets/product_grid.dart';

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
          child: ProductGrid(
            products: products,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            onProductTap: (product) {
              onProductTap?.call();
              context.pushNamed(
                RouteNames.productDetail,
                pathParameters: {'id': product.id},
                extra: product,
              );
            },
          ),
        ),
      ],
    );
  }
}
