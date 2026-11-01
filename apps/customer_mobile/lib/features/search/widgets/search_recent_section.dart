import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Recent search history section
class SearchRecentSection extends StatelessWidget {
  const SearchRecentSection({
    super.key,
    required this.recentSearches,
    required this.onTapItem,
    required this.onRemoveItem,
    required this.onClearAll,
    this.isLoading = false,
  });

  final List<String> recentSearches;
  final ValueChanged<String> onTapItem;
  final ValueChanged<String> onRemoveItem;
  final VoidCallback onClearAll;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox.shrink();
    }

    if (recentSearches.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenPadding,
            vertical: AppSizes.xxl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                IconsaxPlusLinear.search_normal_1,
                size: AppSizes.iconXl,
                color: AppColors.textHint,
              ),
              const SizedBox(height: AppSizes.lg),
              Text(
                'What are you looking for?',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSizes.xs + 2),
              Text(
                'Type a product, brand, or keyword to get started.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Searches',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: onClearAll,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'Clear all',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.xs),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentSearches.length,
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            thickness: 0.6,
            color: AppColors.divider,
          ),
          itemBuilder: (context, index) {
            final item = recentSearches[index];
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: AppSizes.sm + 2,
              minLeadingWidth: 10,
              leading: const Icon(
                IconsaxPlusLinear.clock_1,
                size: 14,
                color: AppColors.textHint,
              ),
              title: Text(
                item,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: AppColors.textHint,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => onRemoveItem(item),
                tooltip: 'Remove',
              ),
              onTap: () => onTapItem(item),
            );
          },
        ),
      ],
    );
  }
}
