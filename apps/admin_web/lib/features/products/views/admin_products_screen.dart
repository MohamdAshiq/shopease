import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../cubits/admin_products_cubit.dart';
import '../widgets/product_filter_toolbar.dart';
import '../widgets/product_kpi_summary_strip.dart';
import '../widgets/products_data_table.dart';

// Admin Products Catalog & Inventory Screen
class AdminProductsScreen extends StatelessWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminProductsCubit()..loadProducts(),
      child: const _ProductsContent(),
    );
  }
}

class _ProductsContent extends StatelessWidget {
  const _ProductsContent();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth < 650
            ? AppSizes.md
            : AppSizes.xl;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: AppSizes.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // KPI Metric Cards
              const ProductKpiSummaryStrip(),
              const SizedBox(height: AppSizes.xl),

              // Filter & Search Toolbar
              const ProductFilterToolbar(),
              const SizedBox(height: AppSizes.lg),

              // Products Data Table
              const ProductsDataTable(),
              const SizedBox(height: AppSizes.xl),
            ],
          ),
        );
      },
    );
  }
}
