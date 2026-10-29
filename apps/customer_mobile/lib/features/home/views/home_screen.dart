import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';
import '../widgets/home_header_curved.dart';
import '../widgets/product_card_vertical.dart';
import '../widgets/promo_banner_slider.dart';

// Customer Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top curved header
            HomeHeaderCurved(
              cartItemCount: 2,
              onCartTap: () {},
              onSearchTap: () {},
              onCategoryTap: (category) {},
            ),

            const SizedBox(height: AppSizes.md),

            // Promo Banner Carousel
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
              child: PromoBannerSlider(),
            ),

            const SizedBox(height: AppSizes.lg),

            // Popular Products Section Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Popular Products', style: AppTextStyles.h3),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'View all',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.sm + 2),

            // Popular Products Grid
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding,
              ),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mockProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSizes.md,
                  mainAxisSpacing: AppSizes.md,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final product = mockProducts[index];
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
              ),
            ),

            const SizedBox(height: AppSizes.xxl),
          ],
        ),
      ),
    );
  }
}
