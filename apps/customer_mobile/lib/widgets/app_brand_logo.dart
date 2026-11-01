import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// ShopEase Logo Widget
class AppBrandLogo extends StatelessWidget {
  const AppBrandLogo({
    super.key,
    this.size = AppSizes.logoSize,
    this.assetPath = AppAssets.appLogo,
  });

  final double size;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        assetPath,
        package: AppAssets.package,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildFallbackVector(),
      ),
    );
  }

  Widget _buildFallbackVector() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.22),
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryLight,
            AppColors.primary,
            AppColors.primaryDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(IconsaxPlusBold.bag_2, size: size * 0.46, color: Colors.white),
          Positioned(
            top: size * 0.22,
            right: size * 0.22,
            child: Container(
              width: size * 0.16,
              height: size * 0.16,
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.star_rounded,
                size: size * 0.12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
