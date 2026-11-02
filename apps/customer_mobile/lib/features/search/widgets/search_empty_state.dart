import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Empty state when search gives no results
class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({
    super.key,
    required this.query,
    required this.onClearQuery,
  });

  final String query;
  final VoidCallback onClearQuery;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenPadding,
          vertical: AppSizes.lg,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/not_found.json',
              package: 'shopease_core',
              width: 180,
              height: 180,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Padding(
                padding: EdgeInsets.all(AppSizes.xl),
                child: Icon(
                  IconsaxPlusLinear.search_status,
                  size: 72,
                  color: AppColors.textHint,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              'No Results Found',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.xs + 2),
            Text(
              'We couldn\'t find any items matching "$query".\nTry adjusting your search',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            AppButton.compact(
              onPressed: onClearQuery,
              icon: IconsaxPlusLinear.refresh,
              label: 'Clear Search',
            ),
          ],
        ),
      ),
    );
  }
}
