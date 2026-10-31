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
    this.size = AppButtonSize.regular,
    this.isFullWidth = false,
    this.isLoading = false,
    this.isOutlined = false,
  });

  const AppButton.compact({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isFullWidth = false,
    this.isLoading = false,
    this.isOutlined = false,
  }) : size = AppButtonSize.compact;

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonSize size;
  final bool isFullWidth;
  final bool isLoading;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    final isCompact = size == AppButtonSize.compact;
    final double height = isCompact ? 40.0 : AppSizes.buttonHeight;
    final double iconSize = isCompact ? 17.0 : 18.0;
    final padding = isCompact
        ? const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
        : const EdgeInsets.symmetric(
            horizontal: AppSizes.lg,
            vertical: AppSizes.sm + 2,
          );
    final contentColor = isOutlined ? AppColors.primary : Colors.white;

    final textStyle = isCompact
        ? AppTextStyles.labelMedium.copyWith(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: contentColor,
          )
        : AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: contentColor,
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
    } else if (icon != null) {
      content = Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: contentColor),
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
        backgroundColor: isOutlined ? Colors.transparent : AppColors.primary,
        foregroundColor: contentColor,
        elevation: 0,
        side: isOutlined
            ? const BorderSide(color: AppColors.primary, width: 1.2)
            : null,
        minimumSize: Size(isFullWidth ? double.infinity : 0.0, height),
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
      child: content,
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, height: height, child: button);
    }

    return button;
  }
}
