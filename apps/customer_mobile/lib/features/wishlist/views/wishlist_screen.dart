import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../cubits/wishlist_cubit.dart';
import '../cubits/wishlist_state.dart';
import '../widgets/wishlist_app_bar.dart';
import '../widgets/wishlist_empty_state.dart';
import '../widgets/wishlist_filter_chips.dart';
import '../widgets/wishlist_item_card.dart';

// Wishlist Screen
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: const WishlistAppBar(),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          if (state.isEmpty) {
            return const WishlistEmptyState();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.sm + AppSizes.xs),

              // Filter Chips Row
              const WishlistFilterChips(),

              const SizedBox(height: AppSizes.md),

              // Product list or empty filtered state
              Expanded(
                child: state.filteredItems.isEmpty
                    ? _EmptyFilteredState(
                        onReset: () => context.read<WishlistCubit>().setFilter(
                          WishlistFilter.all,
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          AppSizes.screenPadding,
                          0,
                          AppSizes.screenPadding,
                          AppSizes.xl,
                        ),
                        itemCount: state.filteredItems.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSizes.md),
                        itemBuilder: (context, index) {
                          final product = state.filteredItems[index];
                          return WishlistItemCard(
                            key: ValueKey('wishlist_item_${product.id}'),
                            product: product,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Empty state when a selected filter has no matches
class _EmptyFilteredState extends StatelessWidget {
  const _EmptyFilteredState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  IconsaxPlusLinear.filter_remove,
                  size: AppSizes.iconXl,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              'No items found',
              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              'No saved items match this filter.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            TextButton(
              onPressed: onReset,
              child: Text(
                'Show All Items',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
