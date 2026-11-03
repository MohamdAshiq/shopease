import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../wishlist/cubits/wishlist_cubit.dart';
import '../../wishlist/cubits/wishlist_state.dart';
import '../../wishlist/utils/wishlist_action_helper.dart';

// Product Hero Image Widget
class ProductHeroImage extends StatelessWidget {
  const ProductHeroImage({super.key, required this.product});

  final ProductModel product;
  static const double imageHeight = 370.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Hero Image Container
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(AppSizes.radiusXl),
            bottomRight: Radius.circular(AppSizes.radiusXl),
          ),
          child: Container(
            height: imageHeight,
            width: double.infinity,
            color: AppColors.scaffoldBackground,
            child: product.imageUrl.isEmpty
                ? const Center(
                    child: Icon(
                      IconsaxPlusLinear.image,
                      size: 64,
                      color: AppColors.textHint,
                    ),
                  )
                : Hero(
                    tag: 'product_image_${product.id}',
                    child: AppNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: imageHeight,
                      iconSize: 64,
                      indicatorSize: 28,
                    ),
                  ),
          ),
        ),

        // Subtle Top Gradient for Button Contrast
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 110,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.38),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // Floating Top App Bar (Back, Share, Wishlist)
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
                  icon: IconsaxPlusLinear.arrow_left,
                  elevation: 3,
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
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
                      elevation: 3,
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                      padding: const EdgeInsets.all(AppSizes.sm + 2),
                      iconSize: AppSizes.iconMd - 2,
                      onTap: () async {
                        await Clipboard.setData(
                          ClipboardData(
                            text: 'Check out ${product.title} on ShopEase',
                          ),
                        );
                        if (context.mounted) {
                          AppSnackBar.show(
                            context,
                            message: 'Link copied to clipboard',
                          );
                        }
                      },
                    ),

                    const SizedBox(width: AppSizes.sm),

                    // Wishlist Button
                    BlocBuilder<WishlistCubit, WishlistState>(
                      buildWhen: (previous, current) =>
                          previous.isFavorite(product.id) !=
                          current.isFavorite(product.id),
                      builder: (context, state) {
                        final isFavorite = state.isFavorite(product.id);
                        return AppCircleButton(
                          icon: isFavorite
                              ? IconsaxPlusBold.heart
                              : IconsaxPlusLinear.heart,
                          elevation: 3,
                          backgroundColor: Colors.white.withValues(alpha: 0.9),
                          padding: const EdgeInsets.all(AppSizes.sm + 2),
                          iconSize: AppSizes.iconMd - 2,
                          iconColor: isFavorite
                              ? AppColors.error
                              : AppColors.textPrimary,
                          onTap: () => WishlistActionHelper.toggleWishlist(
                            context,
                            product: product,
                          ),
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
