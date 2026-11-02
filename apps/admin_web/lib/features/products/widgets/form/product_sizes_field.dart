import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Form input field for managing product sizes
class ProductSizesField extends StatelessWidget {
  const ProductSizesField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final sizes = ProductModel.parseSizes(value.text);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sizes (Optional)',
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (sizes.isNotEmpty)
                  Text(
                    '${sizes.length} ${sizes.length == 1 ? 'size' : 'sizes'} configured',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.xs + 2),
            AppTextField(
              controller: controller,
              hintText: 'e.g. S, M, L, XL or 7, 8, 9, 10 (comma-separated)',
              prefixIcon: IconsaxPlusLinear.ruler,
            ),

            // Live visual badges of sizes
            if (sizes.isNotEmpty) ...[
              const SizedBox(height: AppSizes.xs + 2),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: sizes.map((size) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      size,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        );
      },
    );
  }
}
