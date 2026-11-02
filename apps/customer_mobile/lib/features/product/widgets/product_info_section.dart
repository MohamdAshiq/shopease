import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../cubits/product_detail_cubit.dart';

// Product Info Section in Product Details Page
class ProductInfoSection extends StatelessWidget {
  const ProductInfoSection({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title, Category, Rating & Price
          _ProductTitlePriceHeader(product: product),

          // Dynamic Size Selector
          if (product.sizes.isNotEmpty) ...[
            const SizedBox(height: AppSizes.lg),
            _ProductSizeSelector(sizes: product.sizes),
          ],

          const SizedBox(height: AppSizes.lg),

          // Description Section
          _ProductDescription(description: product.description),

          const SizedBox(height: AppSizes.lg),

          // Service Highlights Row
          const _ProductServiceBadges(),

          const SizedBox(height: AppSizes.xl),
        ],
      ),
    );
  }
}

// Category, rating, title, pricing and stock status
class _ProductTitlePriceHeader extends StatelessWidget {
  const _ProductTitlePriceHeader({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category & Rating Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.sm,
                vertical: AppSizes.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Text(
                product.category.toUpperCase(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 18,
                  color: AppColors.starRating,
                ),
                const SizedBox(width: 3),
                Text(
                  '4.8',
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '(128 reviews)',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: AppSizes.sm + 2),

        // Product Title
        Text(
          product.title,
          style: AppTextStyles.h1.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
        ),

        const SizedBox(height: AppSizes.sm + 2),

        // Price & Discount Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              product.price.inr,
              style: AppTextStyles.priceLarge.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Text(
              product.originalPrice.inr,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textHint,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            DiscountBadge(
              percentage: product.discountPercentage,
              fontSize: 10,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.sm,
                vertical: 3,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSizes.sm),

        // Stock Status Indicator
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: product.isInStock ? AppColors.inStock : AppColors.error,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSizes.xs + 2),
            Text(
              product.isInStock
                  ? 'In Stock (${product.stock} units available)'
                  : 'Out of Stock',
              style: AppTextStyles.bodySmall.copyWith(
                color: product.isInStock ? AppColors.inStock : AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Product Size Selector Widget
class _ProductSizeSelector extends StatelessWidget {
  const _ProductSizeSelector({required this.sizes});

  final List<String> sizes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Size', style: AppTextStyles.h3),
        const SizedBox(height: AppSizes.sm),
        BlocBuilder<ProductDetailCubit, ProductDetailState>(
          buildWhen: (previous, current) =>
              previous.selectedSize != current.selectedSize,
          builder: (context, state) {
            final activeSize = sizes.contains(state.selectedSize)
                ? state.selectedSize
                : sizes.first;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: sizes.map((size) {
                  final isSelected = activeSize == size;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSizes.sm),
                    child: InkWell(
                      onTap: () =>
                          context.read<ProductDetailCubit>().selectSize(size),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.md,
                          vertical: AppSizes.sm,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMd,
                          ),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border,
                            width: 1.2,
                          ),
                        ),
                        child: Text(
                          size,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}

// Product description section
class _ProductDescription extends StatelessWidget {
  const _ProductDescription({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description', style: AppTextStyles.h3),
        const SizedBox(height: AppSizes.xs + 2),
        Text(
          description,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

// Service highlights row (Free delivery, return, authentic)
class _ProductServiceBadges extends StatelessWidget {
  const _ProductServiceBadges();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _ServiceBadge(
            icon: IconsaxPlusLinear.truck_fast,
            label: 'Free Delivery',
          ),
          _ServiceBadge(
            icon: IconsaxPlusLinear.refresh_2,
            label: '7-Day Return',
          ),
          _ServiceBadge(
            icon: IconsaxPlusLinear.shield_tick,
            label: 'Authentic',
          ),
        ],
      ),
    );
  }
}

class _ServiceBadge extends StatelessWidget {
  const _ServiceBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
