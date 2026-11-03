import 'package:carousel_slider/carousel_slider.dart';
import 'package:customer_mobile/features/home/widgets/promo_card.dart';
import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Promo Banner Carousel
class PromoBannerSlider extends StatelessWidget {
  const PromoBannerSlider({super.key, this.products, this.productRepository});

  final List<ProductModel>? products;
  final ProductRepository? productRepository;

  @override
  Widget build(BuildContext context) {
    if (products != null) {
      final available = products!.where((p) => p.isAvailable).toList();
      if (available.isEmpty) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.only(top: AppSizes.md, bottom: AppSizes.lg),
        child: _PromoBannerSliderView(allProducts: available),
      );
    }

    final repo = productRepository ?? FirestoreProductRepository();

    return StreamBuilder<List<ProductModel>>(
      stream: repo.streamProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const SizedBox.shrink();

        final allProducts = snapshot.data ?? const <ProductModel>[];
        final available = allProducts.where((p) => p.isAvailable).toList();

        if (available.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(top: AppSizes.md, bottom: AppSizes.lg),
          child: _PromoBannerSliderView(allProducts: available),
        );
      },
    );
  }
}

class _PromoBannerSliderView extends StatefulWidget {
  const _PromoBannerSliderView({required this.allProducts});

  final List<ProductModel> allProducts;

  @override
  State<_PromoBannerSliderView> createState() => _PromoBannerSliderViewState();
}

class _PromoBannerSliderViewState extends State<_PromoBannerSliderView> {
  final CarouselSliderController _controller = CarouselSliderController();
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _currentPageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayProducts = widget.allProducts.take(3).toList();
    if (displayProducts.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: displayProducts.length,
          options: CarouselOptions(
            height: 185,
            autoPlay: displayProducts.length > 1,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 600),
            autoPlayCurve: Curves.easeInOutCubic,
            viewportFraction: 1.0,
            onPageChanged: (index, _) => _currentPageNotifier.value = index,
          ),
          itemBuilder: (context, index, _) {
            final product = displayProducts[index];
            final theme = _bannerThemes[index % _bannerThemes.length];
            return PromoCard(product: product, theme: theme);
          },
        ),
        if (displayProducts.length > 1) ...[
          const SizedBox(height: AppSizes.sm),
          ValueListenableBuilder<int>(
            valueListenable: _currentPageNotifier,
            builder: (context, activeIndex, _) {
              return _PromoDots(
                itemCount: displayProducts.length,
                currentIndex: activeIndex % displayProducts.length,
                onDotTapped: _controller.animateToPage,
              );
            },
          ),
        ],
      ],
    );
  }
}

// Indicator Dots
class _PromoDots extends StatelessWidget {
  const _PromoDots({
    required this.itemCount,
    required this.currentIndex,
    required this.onDotTapped,
  });

  final int itemCount;
  final int currentIndex;
  final ValueChanged<int> onDotTapped;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => GestureDetector(
          onTap: () => onDotTapped(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: currentIndex == index ? 24 : 7,
            height: 6,
            decoration: BoxDecoration(
              color: currentIndex == index
                  ? AppColors.primary
                  : AppColors.border,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
          ),
        ),
      ),
    );
  }
}

class BannerTheme {
  const BannerTheme({required this.gradient, required this.badgeColor});

  final LinearGradient gradient;
  final Color badgeColor;
}

const _bannerThemes = [
  // First Card Theme
  BannerTheme(
    gradient: LinearGradient(
      colors: [Color(0xFF301B52), Color(0xFF4E287C)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    badgeColor: Color(0xFFFF7A45),
  ),

  // Second Card Theme
  BannerTheme(
    gradient: LinearGradient(
      colors: [Color(0xFF2D1B59), Color(0xFF4C2F8A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    badgeColor: AppColors.primaryLight,
  ),

  // Third Card Theme
  BannerTheme(
    gradient: LinearGradient(
      colors: [Color(0xFF351A52), Color(0xFF552877)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    badgeColor: Color(0xFFFB7185),
  ),
];
