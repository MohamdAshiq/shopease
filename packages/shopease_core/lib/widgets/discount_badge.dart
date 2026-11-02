import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Discount percentage badge
class DiscountBadge extends StatelessWidget {
  const DiscountBadge({
    super.key,
    required this.percentage,
    this.fontSize = 9.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  });

  final int percentage;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (percentage <= 0) return const SizedBox.shrink();

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.discountBadgeBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Text(
        '$percentage% OFF',
        style: TextStyle(
          color: AppColors.discountBadgeText,
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
