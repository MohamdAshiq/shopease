import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../widgets/app_top_bar.dart';
import '../cubits/store_cubit.dart';
import 'store_sort_sheet.dart';

// Store Screen AppBar with Sort action
class StoreAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StoreAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppTopBar(
      title: 'Store',
      showBack: false,
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(
            IconsaxPlusLinear.setting_4,
            color: AppColors.textPrimary,
          ),
          tooltip: 'Sort Options',
          onPressed: () {
            final cubit = context.read<StoreCubit>();
            StoreSortSheet.show(
              context,
              currentSort: cubit.state.selectedSort,
              onSortSelected: cubit.selectSort,
            );
          },
        ),
        const SizedBox(width: AppSizes.xs),
      ],
    );
  }
}
