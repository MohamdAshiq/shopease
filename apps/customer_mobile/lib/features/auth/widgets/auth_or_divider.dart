import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// OR Divider
class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({super.key, this.text = 'OR'});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          child: Text(
            text,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textHint,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}
