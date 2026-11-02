import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../cubits/admin_products_cubit.dart';
import '../cubits/admin_products_state.dart';
import 'filter_dropdown_chip.dart';
import 'product_form_dialog.dart';

// Filter and Search Toolbar for Products Catalog
class ProductFilterToolbar extends StatefulWidget {
  const ProductFilterToolbar({super.key});

  @override
  State<ProductFilterToolbar> createState() => _ProductFilterToolbarState();
}

class _ProductFilterToolbarState extends State<ProductFilterToolbar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<AdminProductsCubit>();
    _searchController = TextEditingController(text: cubit.state.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminProductsCubit, AdminProductsState>(
      listenWhen: (prev, curr) => prev.searchQuery != curr.searchQuery,
      listener: (context, state) {
        if (_searchController.text != state.searchQuery) {
          _searchController.value = TextEditingValue(
            text: state.searchQuery,
            selection: TextSelection.collapsed(
              offset: state.searchQuery.length,
            ),
          );
        }
      },
      child: BlocBuilder<AdminProductsCubit, AdminProductsState>(
        buildWhen: (prev, curr) =>
            prev.searchQuery != curr.searchQuery ||
            prev.selectedCategory != curr.selectedCategory ||
            prev.stockFilter != curr.stockFilter ||
            prev.sortBy != curr.sortBy,
        builder: (context, state) {
          final cubit = context.read<AdminProductsCubit>();

          return LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 1050;

              if (isDesktop) {
                return Row(
                  children: [
                    // Search Field
                    Expanded(flex: 3, child: _buildSearchField(cubit)),
                    const SizedBox(width: AppSizes.md),

                    // Category Dropdown
                    _buildCategoryDropdown(state, cubit),
                    const SizedBox(width: AppSizes.md),

                    // Stock Status Dropdown
                    _buildStockDropdown(state, cubit),
                    const SizedBox(width: AppSizes.md),

                    // Sort Dropdown
                    _buildSortDropdown(state, cubit),
                    const SizedBox(width: AppSizes.md),

                    // Add Product Button
                    AppButton(
                      label: 'Add Product',
                      icon: IconsaxPlusLinear.add,
                      height: AppSizes.buttonHeight,
                      borderRadius: AppSizes.radiusMd,
                      onPressed: () => ProductFormDialog.show(context),
                    ),
                  ],
                );
              }

              // Tablet / Mobile: 2 Rows
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LayoutBuilder(
                    builder: (context, topRowConstraints) {
                      final isVeryNarrow = topRowConstraints.maxWidth < 420;
                      if (isVeryNarrow) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildSearchField(cubit),
                            const SizedBox(height: AppSizes.sm),
                            AppButton(
                              label: 'Add Product',
                              icon: IconsaxPlusLinear.add,
                              isFullWidth: true,
                              height: AppSizes.buttonHeight,
                              borderRadius: AppSizes.radiusMd,
                              onPressed: () => ProductFormDialog.show(context),
                            ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: _buildSearchField(cubit)),
                          const SizedBox(width: AppSizes.sm),
                          AppButton(
                            label: 'Add Product',
                            icon: IconsaxPlusLinear.add,
                            height: AppSizes.buttonHeight,
                            borderRadius: AppSizes.radiusMd,
                            onPressed: () => ProductFormDialog.show(context),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppSizes.sm),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryDropdown(state, cubit),
                        const SizedBox(width: AppSizes.sm),
                        _buildStockDropdown(state, cubit),
                        const SizedBox(width: AppSizes.sm),
                        _buildSortDropdown(state, cubit),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchField(AdminProductsCubit cubit) {
    return SizedBox(
      height: AppSizes.buttonHeight,
      child: AppSearchBar(
        controller: _searchController,
        hintText: 'Search products by title, SKU, or category...',
        fillColor: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: 12,
        ),
        onChanged: cubit.search,
        onClear: () {
          _searchController.clear();
          cubit.search('');
        },
      ),
    );
  }

  Widget _buildCategoryDropdown(
    AdminProductsState state,
    AdminProductsCubit cubit,
  ) {
    final isActive = state.selectedCategory != 'All';

    return FilterDropdownChip<String>(
      value: state.selectedCategory,
      isActive: isActive,
      items: AppCategories.items.map((item) {
        final isItemActive = isActive && state.selectedCategory == item.name;
        return DropdownMenuItem<String>(
          value: item.name,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                size: AppSizes.iconSm - 2,
                color: isItemActive
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: AppSizes.xs + 4),
              Text(item.name == 'All' ? 'All Categories' : item.name),
            ],
          ),
        );
      }).toList(),
      onChanged: (cat) {
        if (cat != null) cubit.filterByCategory(cat);
      },
    );
  }

  Widget _buildStockDropdown(
    AdminProductsState state,
    AdminProductsCubit cubit,
  ) {
    return FilterDropdownChip<StockFilter>(
      value: state.stockFilter,
      isActive: state.stockFilter != StockFilter.all,
      items: const [
        // All Stock Levels
        DropdownMenuItem(
          value: StockFilter.all,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                IconsaxPlusLinear.box,
                size: AppSizes.iconSm - 2,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: AppSizes.xs + 4),
              Text('All Stock Levels'),
            ],
          ),
        ),
        // In Stock
        DropdownMenuItem(
          value: StockFilter.inStock,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                IconsaxPlusLinear.tick_circle,
                size: AppSizes.iconSm - 2,
                color: AppColors.success,
              ),
              SizedBox(width: AppSizes.xs + 4),
              Text('In Stock (≥15)'),
            ],
          ),
        ),
        // Low Stock
        DropdownMenuItem(
          value: StockFilter.lowStock,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                IconsaxPlusLinear.warning_2,
                size: AppSizes.iconSm - 2,
                color: AppColors.warning,
              ),
              SizedBox(width: AppSizes.xs + 4),
              Text('Low Stock (<15)'),
            ],
          ),
        ),
        // Out of Stock
        DropdownMenuItem(
          value: StockFilter.outOfStock,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                IconsaxPlusLinear.close_circle,
                size: AppSizes.iconSm - 2,
                color: AppColors.error,
              ),
              SizedBox(width: AppSizes.xs + 4),
              Text('Out of Stock (0)'),
            ],
          ),
        ),
      ],
      onChanged: (filter) {
        if (filter != null) cubit.filterByStock(filter);
      },
    );
  }

  Widget _buildSortDropdown(
    AdminProductsState state,
    AdminProductsCubit cubit,
  ) {
    return FilterDropdownChip<ProductSortBy>(
      value: state.sortBy,
      isActive: state.sortBy != ProductSortBy.newest,
      items: const [
        // Newest
        DropdownMenuItem(
          value: ProductSortBy.newest,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                IconsaxPlusLinear.calendar_1,
                size: AppSizes.iconSm - 2,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: AppSizes.xs + 4),
              Text('Sort: Newest'),
            ],
          ),
        ),
        // Price: Low to High
        DropdownMenuItem(
          value: ProductSortBy.priceLowToHigh,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                IconsaxPlusLinear.arrow_up_1,
                size: AppSizes.iconSm - 2,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: AppSizes.xs + 4),
              Text('Price: Low to High'),
            ],
          ),
        ),
        // Price: High to Low
        DropdownMenuItem(
          value: ProductSortBy.priceHighToLow,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                IconsaxPlusLinear.arrow_down,
                size: AppSizes.iconSm - 2,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: AppSizes.xs + 4),
              Text('Price: High to Low'),
            ],
          ),
        ),
        // Stock Level
        DropdownMenuItem(
          value: ProductSortBy.stock,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                IconsaxPlusLinear.box_1,
                size: AppSizes.iconSm - 2,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: AppSizes.xs + 4),
              Text('Sort: Stock Level'),
            ],
          ),
        ),
      ],
      onChanged: (sort) {
        if (sort != null) cubit.changeSort(sort);
      },
    );
  }
}
