import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Placeholder view for admin shell routes
class AdminPlaceholderScreen extends StatelessWidget {
  const AdminPlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}
