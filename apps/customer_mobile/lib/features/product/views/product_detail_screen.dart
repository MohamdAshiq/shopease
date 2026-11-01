import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';
import '../../cart/cubits/cart_cubit.dart';
import '../../cart/cubits/cart_state.dart';
import '../../cart/utils/cart_action_helper.dart';
import '../cubits/product_detail_cubit.dart';
import '../widgets/product_bottom_bar.dart';
import '../widgets/product_image_gallery.dart';
import '../widgets/product_info_section.dart';

// Product Detail Screen
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    super.key,
    required this.product,
    this.initialSize,
  });

  final ProductModel product;
  final String? initialSize;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = (initialSize != null && initialSize!.isNotEmpty)
        ? initialSize!
        : (product.sizes.isNotEmpty ? product.sizes.first : '');

    return BlocProvider(
      create: (context) => ProductDetailCubit(initialSize: effectiveSize),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image Gallery with Back and Share buttons
              ProductImageGallery(product: product),

              const SizedBox(height: AppSizes.md + 4),

              // Product Info Widget
              ProductInfoSection(product: product),
            ],
          ),
        ),
        bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            return BlocBuilder<ProductDetailCubit, ProductDetailState>(
              builder: (bottomBarContext, detailState) {
                final isInCart = cartState.isProductInCart(
                  product.id,
                  detailState.selectedSize,
                );

                return ProductBottomBar(
                  product: product,
                  isInCart: isInCart,
                  onAddToCart: (quantity) {
                    CartActionHelper.addToCart(
                      context,
                      product: product,
                      selectedSize: detailState.selectedSize,
                      quantity: quantity,
                    );
                  },
                  onGoToCart: () => context.pushNamed(RouteNames.cart),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
