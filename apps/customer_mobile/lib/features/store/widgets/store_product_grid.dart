import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../widgets/product_grid.dart';

// Product grid
class StoreProductGrid extends StatelessWidget {
  const StoreProductGrid({super.key, required this.products});

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return ProductGrid(products: products);
  }
}
