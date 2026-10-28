import 'package:flutter/material.dart';

// App Colors
abstract final class AppColors {
  // Brand colors
  static const Color primary = Color(0xFF6C3CE1);
  static const Color primaryLight = Color(0xFF8B5CF6);
  static const Color primaryDark = Color(0xFF5228B5);

  static const Color secondary = Color(0xFFFF6B35);
  static const Color secondaryLight = Color(0xFFFF8F66);
  static const Color secondaryDark = Color(0xFFE55A27);

  // Backgrounds & surfaces
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFF8F7FC);

  // Typography colors
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Borders & dividers
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);

  // Status & feedback
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // E-commerce specific indicators
  static const Color starRating = Color(0xFFFFB800);
  static const Color discountBadge = Color(0xFFE11D48);
  static const Color inStock = Color(0xFF10B981);
  static const Color outOfStock = Color(0xFF9CA3AF);
  static const Color cartBadge = Color(0xFFFF6B35);

  // Misc visual effects
  static const Color shadow = Color(0x1A000000);
  static const Color overlay = Color(0x80000000);
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
}
