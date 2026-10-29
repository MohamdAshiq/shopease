import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import 'header_wave_painter.dart';

// HomePage Header with wave curve
class HomeHeaderCurved extends StatelessWidget {
  const HomeHeaderCurved({
    super.key,
    this.cartItemCount = 2,
    this.onCartTap,
    this.onSearchTap,
    this.onCategoryTap,
    this.userName = 'User',
    this.isGuest = false,
  });

  final int cartItemCount;
  final VoidCallback? onCartTap;
  final VoidCallback? onSearchTap;
  final ValueChanged<String>? onCategoryTap;
  final String userName;
  final bool isGuest;

  static const List<_CategoryData> _categories = [
    _CategoryData(label: 'All', icon: IconsaxPlusLinear.category),
    _CategoryData(label: 'Electronics', icon: IconsaxPlusLinear.headphone),
    _CategoryData(label: 'Fashion', icon: IconsaxPlusLinear.tag),
    _CategoryData(label: 'Watches', icon: IconsaxPlusLinear.watch),
    _CategoryData(label: 'Gaming', icon: IconsaxPlusLinear.game),
    _CategoryData(label: 'Home & Kitchen', icon: IconsaxPlusLinear.coffee),
  ];

  @override
  Widget build(BuildContext context) {
    const bottomRadius = Radius.circular(AppSizes.radiusXl + AppSizes.sm);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: bottomRadius,
          bottomRight: bottomRadius,
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: bottomRadius,
          bottomRight: bottomRadius,
        ),
        child: Stack(
          children: [
            // Fluid wave background
            const Positioned.fill(
              child: CustomPaint(painter: HeaderWavePainter()),
            ),

            // Header Content
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.screenPadding,
                  AppSizes.md,
                  AppSizes.screenPadding,
                  AppSizes.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderUserBar(
                      isGuest: isGuest,
                      userName: userName,
                      cartItemCount: cartItemCount,
                      onCartTap: onCartTap,
                    ),
                    const SizedBox(height: AppSizes.md + AppSizes.xs),

                    _HeaderSearchBar(onTap: onSearchTap),
                    const SizedBox(height: AppSizes.lg),

                    _HeaderCategoriesList(
                      categories: _categories,
                      onCategoryTap: onCategoryTap,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// User greeting and cart icon with numeric badge
class _HeaderUserBar extends StatelessWidget {
  const _HeaderUserBar({
    required this.isGuest,
    required this.userName,
    required this.cartItemCount,
    required this.onCartTap,
  });

  final bool isGuest;
  final String userName;
  final int cartItemCount;
  final VoidCallback? onCartTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isGuest ? 'Welcome to ShopEase,' : 'Welcome back,',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              isGuest ? 'Explore Top Deals' : userName,
              style: AppTextStyles.h2.copyWith(color: Colors.white),
            ),
          ],
        ),

        // Cart icon with count badge
        InkWell(
          onTap: onCartTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.sm + 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  IconsaxPlusLinear.bag_2,
                  color: Colors.white,
                  size: AppSizes.iconMd - 2,
                ),
              ),
              if (cartItemCount > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.xs),
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Center(
                      child: Text(
                        '$cartItemCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// SearchBar Widget
class _HeaderSearchBar extends StatelessWidget {
  const _HeaderSearchBar({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg + AppSizes.xs),
      child: Container(
        height: AppSizes.inputHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg + AppSizes.xs),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              IconsaxPlusLinear.search_normal_1,
              color: AppColors.textHint,
              size: 20,
            ),
            const SizedBox(width: AppSizes.sm + 2),
            Text(
              'Search in Store',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Categories List Widget
class _HeaderCategoriesList extends StatelessWidget {
  const _HeaderCategoriesList({required this.categories, this.onCategoryTap});

  final List<_CategoryData> categories;
  final ValueChanged<String>? onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Categories',
          style: AppTextStyles.h3.copyWith(color: Colors.white),
        ),
        const SizedBox(height: AppSizes.sm + AppSizes.xs),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: categories.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSizes.md),
            itemBuilder: (context, index) {
              final cat = categories[index];

              return GestureDetector(
                onTap: () => onCategoryTap?.call(cat.label),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: AppColors.background,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        cat.icon,
                        size: AppSizes.iconMd - 2,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cat.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryData {
  const _CategoryData({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
