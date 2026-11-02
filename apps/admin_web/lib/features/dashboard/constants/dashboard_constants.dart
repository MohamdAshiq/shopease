import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

abstract final class DashboardConstants {
  // Inventory alert stock threshold
  static const int lowStockThreshold = 15;

  // Pagination defaults
  static const int defaultProductsPerPage = 8;
  static const int defaultOrdersPerPage = 8;
  static const int defaultCustomersPerPage = 8;

  // Chart canvas heights
  static const double trendChartHeight = 260.0;
  static const double donutChartHeight = 290.0;

  // UI component dimensions
  static const double mobileBreakpoint = 650.0;
  static const double productThumbnailSize = 44.0;
  static const double adminAvatarSize = 52.0;
  static const double minTableWidth = 650.0;
  static const double productsTableMinWidth = 880.0;
  static const double ordersTableMinWidth = 1080.0;
  static const double customersTableMinWidth = 920.0;
  static const double orderDetailsDrawerWidth = 460.0;
  static const double customerDetailsDrawerWidth = 460.0;
  static const double statCardHeight = 138.0;
  static const double productFormDialogWidth = 580.0;
  static const double deleteDialogWidth = 390.0;
  static const double settingsDialogWidth = 440.0;
  static const double changePasswordDialogWidth = settingsDialogWidth;
  static const double editStoreProfileDialogWidth = settingsDialogWidth;
  static const double statusIndicatorDotSize = 6.0;
  static const double pagerButtonSize = 32.0;

  // Category donut chart color palette
  static const Color categoryElectronics = AppColors.primaryLight;
  static const Color categoryFootwear = AppColors.secondaryLight;
  static const Color categoryAccessories = Color(0xFF60A5FA);
  static const Color categoryGaming = Color(0xFFFBBF24);
  static const Color categoryHomeKitchen = Color(0xFF34D399);
}
