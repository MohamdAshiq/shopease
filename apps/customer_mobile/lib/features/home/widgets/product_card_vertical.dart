import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shopease_core/shopease_core.dart';

// Single product card
class ProductCardVertical extends StatelessWidget {
  const ProductCardVertical({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
  });

  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.border, width: 0.8),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardThumbnail(product: product),
            _CardDetails(product: product, onAddToCart: onAddToCart),
          ],
        ),
      ),
    );
  }
}

// Top thumbnail area with product photo and badges
class _CardThumbnail extends StatelessWidget {
  const _CardThumbnail({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 125,
          width: double.infinity,
          padding: const EdgeInsets.all(AppSizes.sm),
          decoration: const BoxDecoration(
            color: AppColors.scaffoldBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.radiusMd),
              topRight: Radius.circular(AppSizes.radiusMd),
            ),
          ),
          child: Center(
            child: Image.network(
              product.primaryImageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => const Icon(
                IconsaxPlusLinear.image,
                color: AppColors.textHint,
                size: AppSizes.iconLg,
              ),
            ),
          ),
        ),

        // Out of stock overlay
        if (!product.isInStock)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.radiusMd),
                  topRight: Radius.circular(AppSizes.radiusMd),
                ),
              ),
              child: Center(
                child: Text(
                  'OUT OF STOCK',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ),

        // Discount percentage badge
        Positioned(
          top: AppSizes.sm,
          left: AppSizes.sm,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFDE047),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: const Text(
              '20% OFF',
              style: TextStyle(
                color: Color(0xFF854D0E),
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),

        // Wishlist badge
        Positioned(
          top: AppSizes.xs,
          right: AppSizes.xs,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              IconsaxPlusLinear.heart,
              size: AppSizes.iconSm,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

// Product Details Section
class _CardDetails extends StatelessWidget {
  const _CardDetails({required this.product, required this.onAddToCart});

  final ProductModel product;
  final VoidCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    final originalPrice = product.price * 1.25;

    return Padding(
      padding: const EdgeInsets.all(AppSizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category & Star Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  product.category.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textHint,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 14,
                    color: AppColors.starRating,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '4.8',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSizes.xs),

          // Product Title
          Text(
            product.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: AppSizes.xs + 2),

          // Price & Add to Cart Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '₹${product.price.toStringAsFixed(0)}',
                      style: AppTextStyles.priceMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: AppSizes.xs + 2),
                    Flexible(
                      child: Text(
                        '₹${originalPrice.toStringAsFixed(0)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColors.textHint,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Add to cart button
              InkWell(
                onTap: product.isInStock ? onAddToCart : null,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.xs + 2),
                  decoration: BoxDecoration(
                    color: product.isInStock
                        ? AppColors.primary
                        : AppColors.border,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: const Icon(
                    IconsaxPlusLinear.add,
                    color: Colors.white,
                    size: AppSizes.iconSm,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
