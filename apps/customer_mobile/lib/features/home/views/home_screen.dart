import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';
import '../../../widgets/product_grid.dart';
import '../../../widgets/product_grid_skeleton.dart';
import '../../auth/cubits/auth_cubit.dart';
import '../../cart/cubits/cart_cubit.dart';
import '../widgets/home_header_curved.dart';
import '../widgets/promo_banner_slider.dart';

// Customer Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.productRepository});

  final ProductRepository? productRepository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final authState = context.watch<AuthCubit>().state;
    final userName = authState.user?.displayName ?? 'Shopper';
    final isGuest = authState.isGuest;

    final cartItemCount = context.select<CartCubit, int>(
      (cubit) => cubit.state.totalItemCount,
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: StreamBuilder<List<ProductModel>>(
        stream: _productsStream,
        builder: (context, snapshot) {
          final isLoading =
              snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData;
          final allProducts = snapshot.data ?? const <ProductModel>[];
          final availableProducts = allProducts
              .where((p) => p.isAvailable)
              .toList();

          // Dynamically compute category items from available products
          final categoryItems = AppCategories.itemsFromProducts(
            availableProducts,
          );

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top curved header
                HomeHeaderCurved(
                  cartItemCount: cartItemCount,
                  userName: userName,
                  isGuest: isGuest,
                  categories: categoryItems,
                  onCartTap: () => context.pushNamed(RouteNames.cart),
                  onSearchTap: () => context.pushNamed(RouteNames.search),
                  onCategoryTap: (category) => context.go(
                    RoutePaths.storeWithCategory(category),
                    extra: category,
                  ),
                ),

                // Error State Banner
                if (snapshot.hasError) ...[
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.screenPadding),
                    child: AppEmptyState.error(
                      isCompact: true,
                      message: 'Could not load store catalog. Please check your internet connection.',
                      onRetry: _retryStream,
                    ),
                  ),
                ] else ...[
                  // Promo Banner Carousel
                  if (!isLoading)
                    PromoBannerSlider(products: availableProducts),

                  // Popular Products Section Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.screenPadding,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Popular Products', style: AppTextStyles.h3),
                        TextButton(
                          onPressed: () =>
                              context.pushNamed(RouteNames.popularProducts),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'View all',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.sm + 2),

                  // Popular Products Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.screenPadding,
                    ),
                    child: _buildPopularProductsSection(
                      isLoading: isLoading,
                      products: availableProducts,
                    ),
                  ),
                ],

                const SizedBox(height: AppSizes.xxl),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularProductsSection({
    required bool isLoading,
    required List<ProductModel> products,
  }) {
    if (isLoading) {
      return const ProductGridSkeleton(
        itemCount: 4,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
      );
    }

    if (products.isEmpty) {
      return const AppEmptyState(
        isCompact: true,
        icon: IconsaxPlusLinear.box_add,
        title: 'No Popular Products Yet',
        message: 'Check back soon! Newly added products will be featured here.',
      );
    }

    return ProductGrid(
      products: products.take(6).toList(),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
    );
  }
}
