import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../dashboard/constants/dashboard_constants.dart';
import '../../dashboard/widgets/components/admin_table_pagination.dart';
import '../../dashboard/widgets/components/dashboard_card.dart';
import '../cubits/admin_products_cubit.dart';
import '../cubits/admin_products_state.dart';
import 'product_form_dialog.dart';
import 'table/product_table_row_builder.dart';
import 'table/products_table_empty_state.dart';
import 'table/products_table_header.dart';

// Data Table for managing products
class ProductsDataTable extends StatelessWidget {
  const ProductsDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminProductsCubit, AdminProductsState>(
      builder: (context, state) {
        final cubit = context.read<AdminProductsCubit>();
        final paginated = state.paginatedProducts;
        final totalCount = state.filteredProducts.length;
        final int activeFilterCount =
            (state.searchQuery.trim().isNotEmpty ? 1 : 0) +
            (state.selectedCategory != 'All' ? 1 : 0) +
            (state.stockFilter != StockFilter.all ? 1 : 0) +
            (state.sortBy != ProductSortBy.newest ? 1 : 0);
        final hasFilters = activeFilterCount > 0;

        return DashboardCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Table Header Bar
              ProductsTableHeader(
                totalCount: totalCount,
                hasFilters: hasFilters,
                activeFilterCount: activeFilterCount,
                onResetFilters: () {
                  cubit.search('');
                  cubit.filterByCategory('All');
                  cubit.filterByStock(StockFilter.all);
                  cubit.changeSort(ProductSortBy.newest);
                },
              ),

              const Divider(height: 1, thickness: 1, color: AppColors.divider),

              // Table Body (Loading, Empty or Data Rows)
              if (state.status == AdminProductsStatus.loading)
                _buildLoadingState()
              else if (paginated.isEmpty)
                ProductsTableEmptyState(
                  isCatalogEmpty: state.products.isEmpty,
                  onAddProduct: () => ProductFormDialog.show(context),
                  onResetFilters: () {
                    cubit.search('');
                    cubit.filterByCategory('All');
                    cubit.filterByStock(StockFilter.all);
                    cubit.changeSort(ProductSortBy.newest);
                  },
                )
              else
                _buildTableView(context, paginated, cubit),

              const Divider(height: 1, thickness: 1, color: AppColors.divider),

              // Pagination Footer
              if (totalCount > 0 && state.status != AdminProductsStatus.loading)
                AdminTablePagination(
                  currentPage: state.currentPage,
                  totalPages: state.totalPages,
                  totalItems: totalCount,
                  itemsPerPage: state.itemsPerPage,
                  onPageChanged: cubit.changePage,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const Padding(
      padding: EdgeInsets.all(AppSizes.xxl),
      child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );
  }

  Widget _buildTableView(
    BuildContext context,
    List<ProductModel> paginated,
    AdminProductsCubit cubit,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            constraints.maxWidth < DashboardConstants.productsTableMinWidth
            ? DashboardConstants.productsTableMinWidth
            : constraints.maxWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: width,
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(3.4), // Product (Image + Title + SKU)
                1: FlexColumnWidth(1.6), // Category
                2: FlexColumnWidth(1.4), // Price
                3: FlexColumnWidth(1.8), // Stock Level
                4: FlexColumnWidth(1.1), // Availability
                5: FlexColumnWidth(1.3), // Actions
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                ProductTableRowBuilder.buildHeader(),
                ...paginated.asMap().entries.map((entry) {
                  return ProductTableRowBuilder.buildRow(
                    context: context,
                    product: entry.value,
                    cubit: cubit,
                    isEven: entry.key.isEven,
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
