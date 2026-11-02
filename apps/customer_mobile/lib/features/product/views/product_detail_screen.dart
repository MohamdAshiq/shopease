import 'package:customer_mobile/features/product/widgets/product_hero_image.dart';
import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';
import '../../cart/cubits/cart_cubit.dart';
import '../../cart/cubits/cart_state.dart';
import '../../cart/utils/cart_action_helper.dart';
import '../cubits/product_detail_cubit.dart';
import '../widgets/product_bottom_bar.dart';
import '../widgets/product_info_section.dart';

// Product Detail Screen
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    this.product,
    this.productId,
    this.initialSize,
    this.productRepository,
  });

  final ProductModel? product;
  final String? productId;
  final String? initialSize;
  final ProductRepository? productRepository;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Future<ProductModel?>? _productFuture;

  @override
  void initState() {
    super.initState();
    if (widget.product == null &&
        widget.productId != null &&
        widget.productId!.isNotEmpty) {
      final repo = widget.productRepository ?? FirestoreProductRepository();
      _productFuture = repo.getProductById(widget.productId!);
    }
  }

  void _retry() {
    if (widget.productId != null && widget.productId!.isNotEmpty) {
      final repo = widget.productRepository ?? FirestoreProductRepository();
      setState(() {
        _productFuture = repo.getProductById(widget.productId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.product != null) {
      return _ProductDetailContent(
        product: widget.product!,
        initialSize: widget.initialSize,
      );
    }

    if (widget.productId == null || widget.productId!.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        body: Center(
          child: AppEmptyState(
            icon: Icons.inventory_2_outlined,
            title: 'Product Not Found',
            message: 'Invalid product ID or product does not exist.',
            action: AppButton.compact(
              onPressed: () => Navigator.of(context).maybePop(),
              label: 'Go Back',
            ),
          ),
        ),
      );
    }

    return FutureBuilder<ProductModel?>(
      future: _productFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.textPrimary),
            ),
            body: Center(
              child: AppEmptyState.error(
                message: 'Failed to load product details. Please check your internet connection.',
                onRetry: _retry,
              ),
            ),
          );
        }

        final loadedProduct = snapshot.data;
        if (loadedProduct == null) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.textPrimary),
            ),
            body: Center(
              child: AppEmptyState(
                icon: Icons.inventory_2_outlined,
                title: 'Product Not Found',
                message:
                    'This product may have been removed or is unavailable.',
                action: AppButton.compact(
                  onPressed: () => Navigator.of(context).maybePop(),
                  label: 'Go Back',
                ),
              ),
            ),
          );
        }

        return _ProductDetailContent(
          product: loadedProduct,
          initialSize: widget.initialSize,
        );
      },
    );
  }
}

class _ProductDetailContent extends StatelessWidget {
  const _ProductDetailContent({required this.product, this.initialSize});

  final ProductModel product;
  final String? initialSize;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = (initialSize != null && initialSize!.isNotEmpty)
        ? initialSize!
        : (product.sizes.isNotEmpty ? product.sizes.first : '');

    return BlocProvider(
      create: (context) => ProductDetailCubit(initialSize: effectiveSize),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image Gallery with Back and Share buttons
              ProductHeroImage(product: product),

              const SizedBox(height: AppSizes.md + 4),

              // Product Info Widget
              ProductInfoSection(product: product),
            ],
          ),
        ),
        bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            return BlocBuilder<ProductDetailCubit, ProductDetailState>(
              builder: (bottomBarContext, detailState) {
                final isInCart = cartState.isProductInCart(
                  product.id,
                  detailState.selectedSize,
                );

                return ProductBottomBar(
                  product: product,
                  isInCart: isInCart,
                  onAddToCart: (quantity) {
                    CartActionHelper.addToCart(
                      context,
                      product: product,
                      selectedSize: detailState.selectedSize,
                      quantity: quantity,
                    );
                  },
                  onGoToCart: () => context.pushNamed(RouteNames.cart),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
