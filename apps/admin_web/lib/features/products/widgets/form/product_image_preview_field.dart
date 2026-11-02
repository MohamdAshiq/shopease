import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../dashboard/constants/dashboard_constants.dart';

// Text field for image URL with reactive thumbnail
class ProductImagePreviewField extends StatelessWidget {
  const ProductImagePreviewField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    const double thumbnailSize = DashboardConstants.productThumbnailSize + 8;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Primary Image URL',
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSizes.xs + 2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: AppTextField(
                controller: controller,
                hintText: 'https://images.unsplash.com/...',
                prefixIcon: IconsaxPlusLinear.link,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                return Container(
                  width: thumbnailSize,
                  height: thumbnailSize,
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBackground,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    border: Border.all(color: AppColors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: AppNetworkImage(
                    imageUrl: value.text.trim(),
                    fit: BoxFit.cover,
                    iconSize: AppSizes.iconSm,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
