import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// App Search Bar
class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    required this.controller,
    this.focusNode,
    this.autofocus = false,
    this.hintText = 'Search products or categories...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.fillColor,
    this.borderRadius,
    this.borderColor,
    this.contentPadding,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final Color? fillColor;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius =
        borderRadius ?? BorderRadius.circular(AppSizes.radiusLg);
    final effectiveBorderColor = borderColor ?? AppColors.border;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
        prefixIcon: const Icon(
          IconsaxPlusLinear.search_normal_1,
          size: 18,
          color: AppColors.textSecondary,
        ),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, child) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.close_rounded, size: 18),
              onPressed: onClear,
              tooltip: 'Clear',
            );
          },
        ),
        filled: true,
        fillColor: fillColor ?? AppColors.scaffoldBackground,
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(
              vertical: AppSizes.sm,
              horizontal: AppSizes.md,
            ),
        border: OutlineInputBorder(
          borderRadius: effectiveRadius,
          borderSide: BorderSide(color: effectiveBorderColor, width: 0.8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: effectiveRadius,
          borderSide: BorderSide(color: effectiveBorderColor, width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: effectiveRadius,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
        ),
      ),
    );
  }
}
