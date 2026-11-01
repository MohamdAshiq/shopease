import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';
import '../../../widgets/app_circle_button.dart';
import '../../../widgets/app_network_image.dart';
import '../../../widgets/discount_badge.dart';
import '../../../widgets/quick_size_bottom_sheet.dart';
import '../../cart/cubits/cart_cubit.dart';
import '../../cart/cubits/cart_state.dart';
import '../../cart/utils/cart_action_helper.dart';
import '../cubits/wishlist_cubit.dart';

// Single Wishlist Item Card
class WishlistItemCard extends StatelessWidget {
  const WishlistItemCard({super.key, required this.product, this.onTap});

  final ProductModel product;
  final VoidCallback? onTap;

  void _handleTap(BuildContext context) {
    if (onTap != null) {
      onTap!();
      return;
    }
    context.pushNamed(
      RouteNames.productDetail,
      pathParameters: {'id': product.id},
      extra: product,
    );
  }

  void _handleMoveToCart(BuildContext context) {
    if (!product.isInStock) return;

    if (product.sizes.isNotEmpty) {
      QuickSizeBottomSheet.show(context, product: product);
      return;
    }

    CartActionHelper.addToCart(context, product: product);
  }

  void _handleRemove(BuildContext context) {
    final wishlistCubit = context.read<WishlistCubit>();
    wishlistCubit.removeFromWishlist(product.id);

    AppSnackBar.show(
      context,
      message: 'Removed "${product.title}" from wishlist',
      actionLabel: 'UNDO',
      onAction: () => wishlistCubit.addToWishlist(product),
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border, width: 0.8),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleTap(context),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.sm + AppSizes.xs),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Product Thumbnail
                _ThumbnailSection(product: product),

                const SizedBox(width: AppSizes.md),

                // Details and actions
                Expanded(
                  child: _CardDetails(
                    product: product,
                    onRemove: () => _handleRemove(context),
                    onMoveToCart: () => _handleMoveToCart(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Category, Title, Rating, Price, Cart Section
class _CardDetails extends StatelessWidget {
  const _CardDetails({
    required this.product,
    required this.onRemove,
    required this.onMoveToCart,
  });

  final ProductModel product;
  final VoidCallback onRemove;
  final VoidCallback onMoveToCart;

  @override
  Widget build(BuildContext context) {
    final hasDiscount = product.discountPercentage > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Category & Heart Button Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                product.category.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Tooltip(
              message: 'Remove from wishlist',
              child: InkWell(
                onTap: onRemove,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                child: const Padding(
                  padding: EdgeInsets.all(AppSizes.xs),
                  child: Icon(
                    IconsaxPlusBold.heart,
                    size: AppSizes.iconMd - AppSizes.xs,
                    color: AppColors.error,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSizes.xs),

        // Product Title
        Text(
          product.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.25,
          ),
        ),

        const SizedBox(height: AppSizes.sm),

        // Price & Dynamic Cart Action Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(product.price.inr, style: AppTextStyles.priceMedium),
                  if (hasDiscount) ...[
                    const SizedBox(width: AppSizes.sm),
                    Text(
                      product.originalPrice.inr,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textHint,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Cart Action Button
            _CartActionButton(product: product, onMoveToCart: onMoveToCart),
          ],
        ),
      ],
    );
  }
}

// Cart Action Button
class _CartActionButton extends StatelessWidget {
  const _CartActionButton({required this.product, required this.onMoveToCart});

  final ProductModel product;
  final VoidCallback onMoveToCart;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (previous, current) =>
          previous.isAnySizeInCart(product.id) !=
          current.isAnySizeInCart(product.id),
      builder: (context, cartState) {
        if (!product.isInStock) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.sm,
              vertical: AppSizes.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.outOfStock.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Text(
              'Out of Stock',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textHint,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        final isInCart = cartState.isAnySizeInCart(product.id);

        if (isInCart) {
          return Tooltip(
            message: 'Already in cart',
            child: AppCircleButton(
              icon: Icons.check_rounded,
              iconSize: AppSizes.iconSm + 2,
              size: AppSizes.buttonHeight - AppSizes.radiusMd,
              backgroundColor: AppColors.success.withValues(alpha: 0.12),
              iconColor: AppColors.success,
              onTap: () {
                AppSnackBar.show(
                  context,
                  message: '"${product.title}" is already in your cart',
                  actionLabel: 'VIEW CART',
                  onAction: () => context.pushNamed(RouteNames.cart),
                );
              },
            ),
          );
        }

        return Tooltip(
          message: 'Add to cart',
          child: AppCircleButton(
            icon: IconsaxPlusLinear.add,
            iconSize: AppSizes.iconSm + 2,
            size: AppSizes.buttonHeight - AppSizes.radiusMd,
            backgroundColor: AppColors.primary.withValues(alpha: 0.08),
            iconColor: AppColors.primary,
            onTap: onMoveToCart,
          ),
        );
      },
    );
  }
}

// Product thumbnail with discount badge & out of stock indicator
class _ThumbnailSection extends StatelessWidget {
  const _ThumbnailSection({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 96,
          height: 96,
          padding: const EdgeInsets.all(AppSizes.xs),
          decoration: BoxDecoration(
            color: AppColors.scaffoldBackground,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            child: AppNetworkImage(
              imageUrl: product.primaryImageUrl,
              iconSize: AppSizes.iconLg,
              indicatorSize: 20,
            ),
          ),
        ),

        // Discount badge
        if (product.discountPercentage > 0)
          Positioned(
            top: AppSizes.xs,
            left: AppSizes.xs,
            child: DiscountBadge(
              percentage: product.discountPercentage,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.xs + 1,
                vertical: 2,
              ),
            ),
          ),

        // Out of stock overlay
        if (!product.isInStock)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Center(
                child: Text(
                  'OUT OF\nSTOCK',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
