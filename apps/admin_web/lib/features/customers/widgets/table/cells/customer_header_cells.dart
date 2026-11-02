import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Customer Header Cell
class CustomerHeaderCell extends StatelessWidget {
  const CustomerHeaderCell(this.label, {super.key, this.alignRight = false});

  final String label;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.md,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          label,
          textAlign: alignRight ? TextAlign.right : TextAlign.left,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}
