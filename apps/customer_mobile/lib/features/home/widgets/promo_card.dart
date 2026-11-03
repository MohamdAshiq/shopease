import 'package:customer_mobile/app/routing/route_constants.dart';
import 'package:customer_mobile/features/home/widgets/promo_banner_slider.dart';
import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Single Promo Slide Card
class PromoCard extends StatelessWidget {
  const PromoCard({super.key, required this.product, required this.theme});

  final ProductModel product;
  final BannerTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      decoration: BoxDecoration(
        gradient: theme.gradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.gradient.colors.first.withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.pushNamed(
                RouteNames.productDetail,
                pathParameters: {'id': product.id},
                extra: product,
              );
            },
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: _CardContent(product: product, theme: theme),
                ),
                Expanded(
                  flex: 5,
                  child: _CardImage(imageUrl: product.imageUrl),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Left Section: Badge, Title, Pricing and Shop Now CTA
class _CardContent extends StatelessWidget {
  const _CardContent({required this.product, required this.theme});

  final ProductModel product;
  final BannerTheme theme;

  @override
  Widget build(BuildContext context) {
    final badgeText = product.discountPercentage > 0
        ? '${product.discountPercentage}% OFF'
        : 'FEATURED';

    return Padding(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Badge Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: theme.badgeColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Text(
              badgeText,
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Title
          Text(
            product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.h3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),

          // Pricing Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                product.price.inr,
                style: AppTextStyles.h2.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 17,
                ),
              ),
              if (product.originalPrice > product.price) ...[
                const SizedBox(width: 6),
                Text(
                  product.originalPrice.inr,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 11,
                    decoration: TextDecoration.lineThrough,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),

          // Shop Now Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5.5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Shop Now',
                  style: TextStyle(
                    color: theme.gradient.colors.first,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  IconsaxPlusLinear.arrow_right_3,
                  size: 11,
                  color: theme.gradient.colors.first,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Right Section: Circular Product Image Avatar
class _CardImage extends StatelessWidget {
  const _CardImage({required this.imageUrl});

  final String imageUrl;
  static const double _avatarSize = 120.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        0,
        AppSizes.sm,
        AppSizes.md,
        AppSizes.sm,
      ),
      child: Center(
        child: Container(
          width: _avatarSize,
          height: _avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.scaffoldBackground,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.85),
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: AppNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: _avatarSize,
              height: _avatarSize,
              iconSize: 42,
            ),
          ),
        ),
      ),
    );
  }
}
