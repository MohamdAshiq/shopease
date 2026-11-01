import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../cubits/store_cubit.dart';
import 'store_sort_sheet.dart';

// Filter results count Bar
class StoreResultsBar extends StatelessWidget {
  const StoreResultsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSizes.xs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.screenPadding,
        vertical: AppSizes.sm,
      ),
      child: BlocBuilder<StoreCubit, StoreState>(
        buildWhen: (previous, current) =>
            previous.filteredProducts.length !=
                current.filteredProducts.length ||
            previous.selectedSort != current.selectedSort,
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${state.filteredProducts.length} ${state.filteredProducts.length == 1 ? 'Product' : 'Products'}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () {
                  final cubit = context.read<StoreCubit>();
                  StoreSortSheet.show(
                    context,
                    currentSort: state.selectedSort,
                    onSortSelected: cubit.selectSort,
                  );
                },
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.xs,
                    vertical: 2,
                  ),
                  child: Row(
                    children: [
                      Text(
                        state.selectedSort.label,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
