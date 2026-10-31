import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../widgets/app_circle_button.dart';
import '../../../widgets/app_network_image.dart';
import '../cubits/product_detail_cubit.dart';

// Product Image Gallery Widget
class ProductImageGallery extends StatelessWidget {
  const ProductImageGallery({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main Hero Image Container
        Container(
          height: 330,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFF3F3F7),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppSizes.radiusXl + AppSizes.sm),
              bottomRight: Radius.circular(AppSizes.radiusXl + AppSizes.sm),
            ),
          ),
          child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
            buildWhen: (previous, current) =>
                previous.selectedImageIndex != current.selectedImageIndex,
            builder: (context, state) {
              final activeUrl = product.imageUrls.isNotEmpty
                  ? product.imageUrls[state.selectedImageIndex.clamp(
                      0,
                      product.imageUrls.length - 1,
                    )]
                  : product.primaryImageUrl;

              return Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.xl,
                    AppSizes.xxl + AppSizes.md,
                    AppSizes.xl,
                    AppSizes.lg,
                  ),
                  child: Hero(
                    tag: 'product_image_${product.id}',
                    child: AppNetworkImage(
                      imageUrl: activeUrl,
                      iconSize: 64,
                      indicatorSize: 28,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Floating Top App Bar
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPadding,
              vertical: AppSizes.xs,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button
                AppCircleButton(
                  icon: Icons.arrow_back_rounded,
                  elevation: 2,
                  padding: const EdgeInsets.all(AppSizes.sm + 2),
                  iconSize: AppSizes.iconMd - 2,
                  onTap: () => context.pop(),
                ),

                // Right Actions: Share & Wishlist
                Row(
                  children: [
                    // Share Button
                    AppCircleButton(
                      icon: Icons.share_rounded,
                      elevation: 2,
                      padding: const EdgeInsets.all(AppSizes.sm + 2),
                      iconSize: AppSizes.iconMd - 2,
                      onTap: () {},
                    ),

                    const SizedBox(width: AppSizes.sm),

                    // Wishlist Button
                    BlocBuilder<ProductDetailCubit, ProductDetailState>(
                      buildWhen: (previous, current) =>
                          previous.isFavorite != current.isFavorite,
                      builder: (context, state) {
                        return AppCircleButton(
                          icon: state.isFavorite
                              ? IconsaxPlusBold.heart
                              : IconsaxPlusLinear.heart,
                          elevation: 2,
                          padding: const EdgeInsets.all(AppSizes.sm + 2),
                          iconSize: AppSizes.iconMd - 2,
                          iconColor: state.isFavorite
                              ? AppColors.error
                              : AppColors.textPrimary,
                          onTap: () => context
                              .read<ProductDetailCubit>()
                              .toggleFavorite(),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
