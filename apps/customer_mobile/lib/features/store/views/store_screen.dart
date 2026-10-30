import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease_core/shopease_core.dart';

import '../cubits/store_cubit.dart';
import '../widgets/store_category_chips.dart';
import '../widgets/store_empty_state.dart';
import '../widgets/store_product_grid.dart';
import '../widgets/store_results_bar.dart';
import '../widgets/store_search_bar.dart';
import '../widgets/store_sort_sheet.dart';

// Store Screen
class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key, this.initialCategory = 'All'});

  final String initialCategory;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoreCubit(initialCategory: initialCategory),
      child: const _StoreScreenView(),
    );
  }
}

class _StoreScreenView extends StatefulWidget {
  const _StoreScreenView();

  @override
  State<_StoreScreenView> createState() => _StoreScreenViewState();
}

class _StoreScreenViewState extends State<_StoreScreenView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'Store',
          style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
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
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: AppColors.background,
            padding: const EdgeInsets.fromLTRB(
              AppSizes.screenPadding,
              AppSizes.xs,
              AppSizes.screenPadding,
              AppSizes.sm,
            ),
            child: StoreSearchBar(
              controller: _searchController,
              onChanged: (query) {
                context.read<StoreCubit>().updateSearchQuery(query);
              },
              onClear: () {
                _searchController.clear();
                context.read<StoreCubit>().updateSearchQuery('');
              },
            ),
          ),

          // Category Chips
          Container(
            color: AppColors.background,
            padding: const EdgeInsets.only(
              top: AppSizes.sm + 2,
              bottom: AppSizes.md,
            ),
            child: const StoreCategoryChips(),
          ),

          // Results summary Bar
          const StoreResultsBar(),

          // Product Grid or Empty State
          Expanded(
            child: BlocBuilder<StoreCubit, StoreState>(
              buildWhen: (previous, current) =>
                  previous.filteredProducts != current.filteredProducts,
              builder: (context, state) {
                if (state.filteredProducts.isEmpty) {
                  return StoreEmptyState(
                    query: state.searchQuery,
                    onReset: () {
                      _searchController.clear();
                      context.read<StoreCubit>().resetFilters();
                    },
                  );
                }

                return StoreProductGrid(products: state.filteredProducts);
              },
            ),
          ),
        ],
      ),
    );
  }
}
