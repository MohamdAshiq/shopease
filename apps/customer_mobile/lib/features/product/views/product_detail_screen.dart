import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease_core/shopease_core.dart';

import '../cubits/product_detail_cubit.dart';
import '../widgets/product_bottom_bar.dart';
import '../widgets/product_image_gallery.dart';
import '../widgets/product_info_section.dart';

// Product Detail Screen
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailCubit(
        initialSize: product.sizes.isNotEmpty ? product.sizes.first : '',
      ),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image Gallery with Back and Share buttons
              ProductImageGallery(product: product),

              const SizedBox(height: AppSizes.md + 4),

              // Product Info Widget
              ProductInfoSection(product: product),
            ],
          ),
        ),
        bottomNavigationBar: ProductBottomBar(
          product: product,
          onAddToCart: (quantity) {},
        ),
      ),
    );
  }
}
