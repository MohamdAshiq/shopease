import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../cubits/admin_products_cubit.dart';

// Category selector with dynamic dropdown and custom category input option
class ProductCategorySelector extends StatefulWidget {
  const ProductCategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
    this.categories,
  });

  final String selectedCategory;
  final ValueChanged<String> onChanged;
  final List<String>? categories;

  @override
  State<ProductCategorySelector> createState() =>
      _ProductCategorySelectorState();
}

class _ProductCategorySelectorState extends State<ProductCategorySelector> {
  late bool _isCustom;
  late final TextEditingController _customController;

  @override
  void initState() {
    super.initState();
    _isCustom = false;
    _customController = TextEditingController(text: widget.selectedCategory);
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> dynamicNames;
    if (widget.categories != null) {
      dynamicNames = widget.categories!;
    } else {
      List<ProductModel> products = const [];
      try {
        products = context.read<AdminProductsCubit>().state.products;
      } catch (_) {}
      dynamicNames = AppCategories.categoryNamesFromProducts(
        products,
        includeAll: false,
      );
    }
    final categoryNamesSet = <String>{
      ...dynamicNames,
      if (widget.selectedCategory.isNotEmpty &&
          widget.selectedCategory != 'All')
        widget.selectedCategory,
    };

    final sortedNames = categoryNamesSet.toList()..sort();
    final availableCategories = AppCategories.itemsFromNames(sortedNames);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Category',
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _isCustom = !_isCustom;
                  if (_isCustom) {
                    _customController.text = widget.selectedCategory;
                  } else {
                    if (availableCategories.isNotEmpty) {
                      widget.onChanged(availableCategories.first.name);
                    }
                  }
                });
              },
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  _isCustom ? 'Choose from list' : '+ New Category',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.xs + 2),
        if (_isCustom)
          AppTextField(
            controller: _customController,
            hintText: 'e.g. Sports, Beauty, Books...',
            prefixIcon: IconsaxPlusLinear.category,
            onChanged: (val) => widget.onChanged(val.trim()),
            validator: (val) =>
                AppValidators.validateRequired(val, 'category name'),
          )
        else
          Container(
            height: AppSizes.inputHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value:
                    availableCategories.any(
                      (c) =>
                          c.name.toLowerCase() ==
                          widget.selectedCategory.toLowerCase(),
                    )
                    ? availableCategories
                          .firstWhere(
                            (c) =>
                                c.name.toLowerCase() ==
                                widget.selectedCategory.toLowerCase(),
                          )
                          .name
                    : (availableCategories.isNotEmpty
                          ? availableCategories.first.name
                          : 'General'),
                focusColor: Colors.transparent,
                dropdownColor: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                isExpanded: true,
                icon: const Icon(
                  IconsaxPlusLinear.arrow_down,
                  size: AppSizes.iconSm,
                  color: AppColors.textSecondary,
                ),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                items: availableCategories.map((item) {
                  final isSelected =
                      widget.selectedCategory.toLowerCase() ==
                      item.name.toLowerCase();
                  return DropdownMenuItem<String>(
                    value: item.name,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.icon,
                          size: AppSizes.iconSm - 2,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Text(item.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) widget.onChanged(val);
                },
              ),
            ),
          ),
      ],
    );
  }
}
