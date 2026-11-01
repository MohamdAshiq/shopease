import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import '../features/cart/utils/cart_action_helper.dart';

// Bottom Sheet for selecting size
class QuickSizeBottomSheet extends StatefulWidget {
  const QuickSizeBottomSheet({
    super.key,
    required this.product,
    this.onSizeSelected,
  });

  final ProductModel product;
  final ValueChanged<String>? onSizeSelected;

  // Shows the size bottom sheet modal
  static Future<void> show(
    BuildContext context, {
    required ProductModel product,
    ValueChanged<String>? onSizeSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => QuickSizeBottomSheet(
        product: product,
        onSizeSelected: onSizeSelected,
      ),
    );
  }

  @override
  State<QuickSizeBottomSheet> createState() => _QuickSizeBottomSheetState();
}

class _QuickSizeBottomSheetState extends State<QuickSizeBottomSheet> {
  late String _selectedSize;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.product.sizes.isNotEmpty
        ? widget.product.sizes.first
        : '';
  }

  void _handleAddToCart() {
    Navigator.of(context).pop();

    if (widget.onSizeSelected != null) {
      widget.onSizeSelected!(_selectedSize);
      return;
    }

    CartActionHelper.addToCart(
      context,
      product: widget.product,
      selectedSize: _selectedSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLg),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.screenPadding,
            AppSizes.sm,
            AppSizes.screenPadding,
            AppSizes.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSizes.md),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Product preview row
              Row(
                children: [
                  // Thumbnail
                  Container(
                    width: 48,
                    height: 48,
                    padding: const EdgeInsets.all(AppSizes.xs),
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldBackground,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      border: Border.all(color: AppColors.border, width: 0.8),
                    ),
                    child: AppNetworkImage(
                      imageUrl: product.primaryImageUrl,
                      iconSize: AppSizes.iconSm,
                      indicatorSize: 14,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm + 2),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.labelLarge.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product.price.inr,
                          style: AppTextStyles.priceMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Close button
                  AppCircleButton(
                    icon: Icons.close_rounded,
                    iconSize: 18,
                    padding: const EdgeInsets.all(6),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),

              const Divider(color: AppColors.divider, height: AppSizes.lg + 4),

              // "Select Size" label
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Size',
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (_selectedSize.isNotEmpty)
                    Text(
                      'Size: $_selectedSize',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: AppSizes.sm + 2),

              // Size Chips
              Wrap(
                spacing: AppSizes.sm,
                runSpacing: AppSizes.sm,
                children: product.sizes.map((size) {
                  final isSelected = size == _selectedSize;

                  return InkWell(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedSize = size);
                    },
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.md,
                        vertical: AppSizes.sm,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.scaffoldBackground,
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                          width: isSelected ? 1.4 : 1.0,
                        ),
                      ),
                      child: Text(
                        size,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: AppSizes.lg + 4),

              // Add to Cart Button
              AppButton(
                onPressed: _handleAddToCart,
                icon: IconsaxPlusBold.bag_2,
                label: 'Add to Cart • ${product.price.inr}',
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
