import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

abstract final class DashboardConstants {
  // Inventory alert stock threshold
  static const int lowStockThreshold = 15;

  // Chart canvas heights
  static const double trendChartHeight = 260.0;
  static const double donutChartHeight = 290.0;

  // UI component dimensions
  static const double productThumbnailSize = 44.0;
  static const double minTableWidth = 650.0;
  static const double statCardHeight = 130.0;

  // Category donut chart color palette
  static const Color categoryElectronics = AppColors.primaryLight;
  static const Color categoryFootwear = AppColors.secondaryLight;
  static const Color categoryAccessories = Color(0xFF60A5FA);
  static const Color categoryGaming = Color(0xFFFBBF24);
  static const Color categoryHomeKitchen = Color(0xFF34D399);
}
