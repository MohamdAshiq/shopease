import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';

// Animated splash screen on initial launch
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    _timer = Timer(const Duration(milliseconds: 1600), () {
      if (mounted) {
        context.go(RoutePaths.home);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Branded App Logo
                const AppBrandLogo(size: 120),
                const SizedBox(height: AppSizes.md),

                // Brand Name
                Text(
                  'ShopEase',
                  style: AppTextStyles.h1.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),

                // Tagline
                Text(
                  'Smart Shopping, Delivered Ease',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: AppSizes.xxl),

                // Minimal branded progress loader
                const SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
