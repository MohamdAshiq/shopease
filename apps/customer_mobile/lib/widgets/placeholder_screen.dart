import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Placeholder screen
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(title, style: AppTextStyles.h3),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppSizes.iconXl + AppSizes.sm,
              color: AppColors.textHint,
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              '$title Screen',
              style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
