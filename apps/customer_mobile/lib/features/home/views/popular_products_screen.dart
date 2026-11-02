import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../widgets/app_top_bar.dart';
import '../../../widgets/product_grid.dart';
import '../../../widgets/product_grid_skeleton.dart';

// Popular Products Screen
class PopularProductsScreen extends StatefulWidget {
  const PopularProductsScreen({super.key, this.productRepository});

  final ProductRepository? productRepository;

  @override
  State<PopularProductsScreen> createState() => _PopularProductsScreenState();
}

class _PopularProductsScreenState extends State<PopularProductsScreen> {
  late final ProductRepository _repo;
  late Stream<List<ProductModel>> _productsStream;

  @override
  void initState() {
    super.initState();
    _repo = widget.productRepository ?? FirestoreProductRepository();
    _productsStream = _repo.streamProducts();
  }

  void _retryStream() {
    setState(() {
      _productsStream = _repo.streamProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: const AppTopBar(title: 'Popular Products'),
      body: StreamBuilder<List<ProductModel>>(
        stream: _productsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return AppEmptyState.error(
              message: 'Failed to load popular products. Please check your internet connection.',
              onRetry: _retryStream,
            );
          }

          final isLoading =
              snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData;
          final allProducts = snapshot.data ?? const <ProductModel>[];
          final products = allProducts.where((p) => p.isAvailable).toList();

          if (isLoading) {
            return const ProductGridSkeleton(
              itemCount: 6,
              padding: EdgeInsets.all(AppSizes.screenPadding),
            );
          }

          if (products.isEmpty) {
            return const AppEmptyState(
              icon: IconsaxPlusLinear.box_add,
              title: 'No Popular Products Yet',
              message: 'Check back soon! Products added to the store catalog will appear here.',
            );
          }

          return ProductGrid(
            products: products,
            padding: const EdgeInsets.all(AppSizes.screenPadding),
          );
        },
      ),
    );
  }
}
