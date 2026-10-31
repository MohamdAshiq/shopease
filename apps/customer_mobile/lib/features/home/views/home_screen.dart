import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';
import '../../../widgets/product_grid.dart';
import '../../cart/cubits/cart_cubit.dart';
import '../widgets/home_header_curved.dart';
import '../widgets/promo_banner_slider.dart';

// Customer Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItemCount = context.select<CartCubit, int>(
      (cubit) => cubit.state.totalItemCount,
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top curved header
            HomeHeaderCurved(
              cartItemCount: cartItemCount,
              onCartTap: () => context.pushNamed(RouteNames.cart),
              onSearchTap: () => context.pushNamed(RouteNames.search),
              onCategoryTap: (category) => context.go(
                RoutePaths.storeWithCategory(category),
                extra: category,
              ),
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
              child: ProductGrid(
                products: mockProducts,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
              ),
            ),

            const SizedBox(height: AppSizes.xxl),
          ],
        ),
      ),
    );
  }
}
