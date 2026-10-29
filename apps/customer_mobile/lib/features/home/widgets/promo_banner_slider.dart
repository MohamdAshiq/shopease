import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease_core/shopease_core.dart';

import '../cubits/promo_banner_cubit.dart';

// Promo carousel banner
class PromoBannerSlider extends StatelessWidget {
  const PromoBannerSlider({super.key});

  final List<_PromoBannerData> _banners = const [
    _PromoBannerData(
      title: 'SNEAKERS OF\nTHE WEEK',
      subtitle: 'Nike Air Max Pulse',
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&q=80',
      badgeText: '20% OFF',
    ),
    _PromoBannerData(
      title: 'PURE NOISE\nCANCELLATION',
      subtitle: 'Sony WH-1000XM5',
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&q=80',
      badgeText: 'NEW',
    ),
    _PromoBannerData(
      title: 'TACTILE RGB\nKEYBOARD',
      subtitle: 'Ergonomic Mechanical',
      imageUrl: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=80',
      badgeText: 'HOT',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PromoBannerCubit(),
      child: _PromoBannerSliderView(banners: _banners),
    );
  }
}

class _PromoBannerSliderView extends StatefulWidget {
  const _PromoBannerSliderView({required this.banners});

  final List<_PromoBannerData> banners;

  @override
  State<_PromoBannerSliderView> createState() => _PromoBannerSliderViewState();
}

class _PromoBannerSliderViewState extends State<_PromoBannerSliderView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 190,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.banners.length,
            onPageChanged: (index) {
              context.read<PromoBannerCubit>().setPage(index);
            },
            itemBuilder: (context, index) {
              final banner = widget.banners[index];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSizes.xs),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF8F8FB), Color(0xFFE4E4EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  border: Border.all(
                    color: const Color(0xFFD8D8E0),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  child: Row(
                    children: [
                      // Left Column: Badge, Title, Subtitle
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(AppSizes.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.sm,
                                  vertical: AppSizes.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.radiusSm,
                                  ),
                                ),
                                child: Text(
                                  banner.badgeText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSizes.sm),
                              Text(
                                banner.title,
                                style: AppTextStyles.h2.copyWith(
                                  height: 1.15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: AppSizes.xs),
                              Text(
                                banner.subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Right Column: Dedicated Hero Product Image
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            0,
                            AppSizes.sm,
                            AppSizes.md,
                            AppSizes.sm,
                          ),
                          child: Center(
                            child: Image.network(
                              banner.imageUrl,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 48,
                                    color: AppColors.textHint,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSizes.sm + 2),

        // Dots indicators
        BlocBuilder<PromoBannerCubit, int>(
          builder: (context, currentPage) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.banners.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: currentPage == index ? 24 : 7,
                  height: 6,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? AppColors.primary
                        : AppColors.border,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _PromoBannerData {
  const _PromoBannerData({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.badgeText,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final String badgeText;
}
