import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Admin Branding Side of the Login Screen
class AdminBrandingSide extends StatelessWidget {
  const AdminBrandingSide({super.key, required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF160D2E),
            Color(0xFF281352),
            Color(0xFF4A1E8C),
            Color(0xFF5B21B6),
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? AppSizes.xxl : AppSizes.xl,
        vertical: isDesktop ? AppSizes.xxl : AppSizes.xl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isDesktop ? 520 : 420),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Text(
                'SHOPEASE ADMIN',
                style: AppTextStyles.h2.copyWith(
                  color: Colors.white,
                  letterSpacing: 2,
                  fontSize: isDesktop ? 26 : 22,
                  fontWeight: FontWeight.w700,
                ),
              ),

              // Lottie Animation
              LottieBuilder.asset(
                AppAssets.loginAnimation,
                package: AppAssets.package,
                height: isDesktop ? 340 : 240,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: AppSizes.sm),

              // Subheading
              Text(
                'Manage ShopEase with Ease',
                style: AppTextStyles.h2.copyWith(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontSize: isDesktop ? 20 : 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.sm),

              // Description
              Text(
                'Your control center for products, orders, inventory and platform operations.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
