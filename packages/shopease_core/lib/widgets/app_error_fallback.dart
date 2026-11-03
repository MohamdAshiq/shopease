import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import 'app_empty_state.dart';

// Error Widget Fallback
class AppErrorFallback extends StatelessWidget {
  const AppErrorFallback({
    super.key,
    this.details,
    this.title = 'Something went wrong',
    this.message = 'Please restart the application or try again.',
    this.onRetry,
  });

  final FlutterErrorDetails? details;
  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.scaffoldBackground,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: AppEmptyState.error(
            title: title,
            message: message,
            onRetry: onRetry,
          ),
        ),
      ),
    );
  }
}
