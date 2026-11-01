import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';

// Utility helper for SnackBar
abstract final class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Color? backgroundColor,
    Duration duration = const Duration(milliseconds: 2500),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        dismissDirection: DismissDirection.down,
        persist: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: () {
                  messenger.hideCurrentSnackBar();
                  onAction();
                },
              )
            : null,
      ),
    );
  }

  // Error Snackbar
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      backgroundColor: AppColors.error,
      duration: duration,
    );
  }

  // Success Snackbar
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      backgroundColor: AppColors.success,
      duration: duration,
    );
  }
}
