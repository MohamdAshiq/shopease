import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Button size variants
enum AppButtonSize { regular, compact }

// Reusable App Button
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.customIcon,
    this.size = AppButtonSize.regular,
    this.isFullWidth = false,
    this.isLoading = false,
    this.isOutlined = false,
    this.isDestructive = false,
    this.borderRadius,
    this.borderColor,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.fontSize,
  });

  const AppButton.compact({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.customIcon,
    this.isFullWidth = false,
    this.isLoading = false,
    this.isOutlined = false,
    this.isDestructive = false,
    this.borderRadius,
    this.borderColor,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.fontSize,
  }) : size = AppButtonSize.compact;

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Widget? customIcon;
  final AppButtonSize size;
  final bool isFullWidth;
  final bool isLoading;
  final bool isOutlined;
  final bool isDestructive;
  final double? borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final isCompact = size == AppButtonSize.compact;
    final double btnHeight =
        height ?? (isCompact ? 40.0 : AppSizes.buttonHeight);
    final double iconSize = isCompact ? 17.0 : 18.0;
    final padding = isCompact
        ? const EdgeInsets.symmetric(
            horizontal: AppSizes.md + AppSizes.xs,
            vertical: AppSizes.sm + 2,
          )
        : const EdgeInsets.symmetric(
            horizontal: AppSizes.lg,
            vertical: AppSizes.sm + 2,
          );
    final activeColor = isDestructive ? AppColors.error : AppColors.primary;
    final contentColor = textColor ?? (isOutlined ? activeColor : Colors.white);

    final textStyle =
        (isCompact ? AppTextStyles.labelMedium : AppTextStyles.labelLarge)
            .copyWith(
              fontWeight: FontWeight.w600,
              color: contentColor,
              fontSize: fontSize,
            );

    Widget content;
    if (isLoading) {
      content = SizedBox(
        width: iconSize + 2.0,
        height: iconSize + 2.0,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(contentColor),
        ),
      );
    } else if (customIcon != null || icon != null) {
      final leadIcon =
          customIcon ?? Icon(icon!, size: iconSize, color: contentColor);
      content = Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          leadIcon,
          const SizedBox(width: AppSizes.sm),
          Text(label, style: textStyle),
        ],
      );
    } else {
      content = Text(label, style: textStyle);
    }

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            backgroundColor ??
            (isOutlined
                ? (isDestructive
                      ? AppColors.error.withValues(alpha: 0.04)
                      : Colors.transparent)
                : activeColor),
        foregroundColor: contentColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        overlayColor: isOutlined
            ? (isDestructive
                  ? AppColors.error.withValues(alpha: 0.08)
                  : AppColors.primary.withValues(alpha: 0.05))
            : Colors.white.withValues(alpha: 0.16),
        side: isOutlined
            ? BorderSide(
                color:
                    borderColor ??
                    (isDestructive
                        ? AppColors.error.withValues(alpha: 0.45)
                        : AppColors.primary),
                width: 1.0,
              )
            : null,
        minimumSize: Size(isFullWidth ? double.infinity : 0.0, btnHeight),
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppSizes.radiusMd,
          ),
        ),
      ),
      child: content,
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, height: btnHeight, child: button);
    }

    return button;
  }
}
