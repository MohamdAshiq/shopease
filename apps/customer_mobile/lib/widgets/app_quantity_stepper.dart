import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

// Item Quantity Selector Widget
class AppQuantityStepper extends StatelessWidget {
  const AppQuantityStepper({
    super.key,
    required this.quantity,
    this.onDecrement,
    this.onIncrement,
    this.isCompact = false,
  });

  final int quantity;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(
      isCompact ? AppSizes.radiusSm : AppSizes.radiusMd,
    );
    final iconSize = isCompact ? 14.0 : 18.0;
    final buttonPadding = isCompact ? 6.0 : (AppSizes.xs + 2);
    final textStyle = isCompact
        ? AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w700)
        : AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w700);

    return Container(
      height: isCompact ? null : AppSizes.buttonHeight,
      padding: EdgeInsets.symmetric(horizontal: isCompact ? 0 : 4),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: borderRadius,
        border: Border.all(
          color: AppColors.border,
          width: isCompact ? 0.8 : 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperIconButton(
            icon: IconsaxPlusLinear.minus,
            onTap: onDecrement,
            padding: buttonPadding,
            iconSize: iconSize,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? AppSizes.sm : (AppSizes.sm + 2),
            ),
            child: Text('$quantity', style: textStyle),
          ),
          _StepperIconButton(
            icon: IconsaxPlusLinear.add,
            onTap: onIncrement,
            padding: buttonPadding,
            iconSize: iconSize,
          ),
        ],
      ),
    );
  }
}

class _StepperIconButton extends StatelessWidget {
  const _StepperIconButton({
    required this.icon,
    required this.padding,
    required this.iconSize,
    this.onTap,
  });

  final IconData icon;
  final double padding;
  final double iconSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;

    return InkWell(
      onTap: onTap != null
          ? () {
              HapticFeedback.selectionClick();
              onTap!();
            }
          : null,
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Opacity(
          opacity: isEnabled ? 1.0 : 0.25,
          child: Icon(
            icon,
            size: iconSize,
            color: isEnabled ? AppColors.textPrimary : AppColors.textHint,
          ),
        ),
      ),
    );
  }
}
