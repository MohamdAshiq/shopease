import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Search Screen AppBar
class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
    this.onBack,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 60,
          padding: const EdgeInsets.fromLTRB(
            AppSizes.xs,
            AppSizes.xs,
            AppSizes.screenPadding,
            AppSizes.xs,
          ),
          decoration: const BoxDecoration(
            color: AppColors.background,
            border: Border(
              bottom: BorderSide(color: AppColors.border, width: 0.8),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: onBack ?? () => Navigator.of(context).pop(),
                icon: const Icon(
                  IconsaxPlusLinear.arrow_left,
                  color: AppColors.textPrimary,
                  size: 22,
                ),
                tooltip: 'Back',
              ),
              Expanded(
                child: AppSearchBar(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: true,
                  hintText: 'Search products or categories...',
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  onClear: onClear,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
