import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Network Image Widget
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.iconSize = AppSizes.iconMd,
    this.indicatorSize = 20.0,
  });

  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final double iconSize;
  final double indicatorSize;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Icon(
            IconsaxPlusLinear.image,
            color: AppColors.textHint,
            size: iconSize,
          ),
        ),
      );
    }

    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Center(
          child: SizedBox(
            width: indicatorSize,
            height: indicatorSize,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Center(
        child: Icon(
          IconsaxPlusLinear.image,
          color: AppColors.textHint,
          size: iconSize,
        ),
      ),
    );
  }
}
