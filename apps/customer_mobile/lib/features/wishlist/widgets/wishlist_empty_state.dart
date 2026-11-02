import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';

// Wishlist Empty State
class WishlistEmptyState extends StatelessWidget {
  const WishlistEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.xxl,
          vertical: AppSizes.xl,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  IconsaxPlusLinear.heart_slash,
                  size: AppSizes.iconXl,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: AppSizes.lg),

            // Heading
            Text(
              'Your Wishlist is Empty',
              textAlign: TextAlign.center,
              style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: AppSizes.sm),

            // Description
            Text(
              'Explore products and tap the heart icon to save items you love for later.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),

            const SizedBox(height: AppSizes.xl),

            // Explore Store CTA
            AppButton(
              label: 'Explore Store',
              icon: IconsaxPlusLinear.shop,
              onPressed: () => context.goNamed(RouteNames.store),
            ),
          ],
        ),
      ),
    );
  }
}
