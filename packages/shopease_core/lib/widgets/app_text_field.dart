import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Custom Text Field
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.initialValue,
    this.prefixIcon,
    this.prefixWidget,
    this.suffixIcon,
    this.obscureText = false,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: AppSizes.md,
      vertical: AppSizes.md - 2,
    ),
    this.labelStyle,
    this.borderless = true,
    this.fillColor,
    this.borderRadius,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final TextStyle? labelStyle;
  final String? hintText;
  final String? initialValue;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final AutovalidateMode autovalidateMode;
  final EdgeInsetsGeometry contentPadding;
  final bool borderless;
  final Color? fillColor;
  final double? borderRadius;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.isPassword || widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isPassword && oldWidget.obscureText != widget.obscureText) {
      _obscured = widget.obscureText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? AppSizes.radiusMd;
    final defaultBorderSide = widget.borderless
        ? BorderSide.none
        : const BorderSide(color: AppColors.border);

    final resolvedFillColor =
        widget.fillColor ??
        (widget.enabled
            ? (widget.borderless
                  ? AppColors.scaffoldBackground
                  : AppColors.surface)
            : AppColors.divider);

    Widget? leading;
    if (widget.prefixWidget != null) {
      leading = Padding(
        padding: const EdgeInsets.only(left: 14, right: 10),
        child: widget.prefixWidget,
      );
    } else if (widget.prefixIcon != null) {
      leading = Padding(
        padding: const EdgeInsets.only(left: 14, right: 10),
        child: Icon(
          widget.prefixIcon,
          size: 19,
          color: widget.borderless
              ? AppColors.textHint
              : AppColors.textSecondary,
        ),
      );
    }

    Widget? trailing = widget.suffixIcon;
    if (widget.isPassword) {
      trailing = IconButton(
        icon: Icon(
          _obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.textHint,
          size: 20,
        ),
        onPressed: () => setState(() => _obscured = !_obscured),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style:
                widget.labelStyle ??
                AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: AppSizes.xs + 2),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          initialValue: widget.initialValue,
          obscureText: _obscured,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          autovalidateMode: widget.autovalidateMode,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
            isDense: true,
            contentPadding: widget.contentPadding,
            prefixIcon: leading,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 44,
              minHeight: AppSizes.buttonHeight,
            ),
            suffixIcon: trailing != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: trailing,
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 44,
              minHeight: AppSizes.buttonHeight,
            ),
            filled: true,
            fillColor: resolvedFillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: defaultBorderSide,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: defaultBorderSide,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            errorStyle: AppTextStyles.labelSmall.copyWith(
              color: AppColors.error,
            ),
          ),
        ),
      ],
    );
  }
}
