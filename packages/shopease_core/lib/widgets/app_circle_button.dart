import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

// Circular Icon Button
class AppCircleButton extends StatelessWidget {
  const AppCircleButton({
    super.key,
    required this.icon,
    this.onTap,
    this.iconColor = AppColors.textPrimary,
    this.backgroundColor = AppColors.background,
    this.size,
    this.iconSize = AppSizes.iconSm,
    this.padding = const EdgeInsets.all(AppSizes.sm),
    this.elevation = 0,
    this.hasShadow = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color iconColor;
  final Color backgroundColor;
  final double? size;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final bool hasShadow;

  @override
  Widget build(BuildContext context) {
    Widget button = Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      elevation: elevation,
      shadowColor: AppColors.shadow,
      child: InkWell(
        onTap: onTap != null
            ? () {
                HapticFeedback.selectionClick();
                onTap!();
              }
            : null,
        customBorder: const CircleBorder(),
        child: Container(
          width: size,
          height: size,
          padding: padding,
          child: Center(
            child: Icon(icon, size: iconSize, color: iconColor),
          ),
        ),
      ),
    );

    if (hasShadow && elevation == 0) {
      button = Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: button,
      );
    }

    return button;
  }
}
