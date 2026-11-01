import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import '../cubits/wishlist_cubit.dart';
import '../cubits/wishlist_state.dart';

// Wishlist Filter Chips
class WishlistFilterChips extends StatelessWidget {
  const WishlistFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      buildWhen: (previous, current) =>
          previous.selectedFilter != current.selectedFilter ||
          previous.items != current.items,
      builder: (context, state) {
        final chips = [
          _ChipData(
            filter: WishlistFilter.all,
            label: 'All (${state.itemCount})',
          ),
          _ChipData(
            filter: WishlistFilter.inStock,
            label: 'In Stock (${state.inStockCount})',
          ),
          _ChipData(
            filter: WishlistFilter.discount,
            label: 'Discount (${state.discountCount})',
          ),
        ];

        return SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPadding,
            ),
            itemCount: chips.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSizes.sm),
            itemBuilder: (context, index) {
              final chip = chips[index];
              final isSelected = state.selectedFilter == chip.filter;

              return InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.read<WishlistCubit>().setFilter(chip.filter);
                },
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md + 2,
                    vertical: AppSizes.xs + 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.scaffoldBackground,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      chip.label,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _ChipData {
  const _ChipData({required this.filter, required this.label});
  final WishlistFilter filter;
  final String label;
}
