import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

enum DashboardOverviewStatus { initial, loading, loaded, error }

enum ChartTimeframe { weekly, monthly, yearly }

class KpiMetrics {
  const KpiMetrics({
    required this.totalRevenue,
    required this.totalOrdersCount,
    required this.activeProductsCount,
    required this.lowStockCount,
    required this.pendingOrdersCount,
    required this.categoryCount,
  });

  final double totalRevenue;
  final int totalOrdersCount;
  final int activeProductsCount;
  final int lowStockCount;
  final int pendingOrdersCount;
  final int categoryCount;
}

class RevenueChartData {
  const RevenueChartData({
    required this.timeframe,
    required this.spots,
    required this.totalRevenueText,
    required this.percentageChangeText,
    required this.maxX,
    required this.maxY,
    required this.horizontalInterval,
  });

  final ChartTimeframe timeframe;
  final List<FlSpot> spots;
  final String totalRevenueText;
  final String percentageChangeText;
  final double maxX;
  final double maxY;
  final double horizontalInterval;
}

class CategoryBreakdownItem {
  const CategoryBreakdownItem({
    required this.name,
    required this.percentage,
    required this.revenue,
    required this.color,
  });

  final String name;
  final int percentage;
  final String revenue;
  final Color color;
}

class DashboardOverviewState extends Equatable {
  const DashboardOverviewState({
    this.status = DashboardOverviewStatus.initial,
    this.kpiMetrics = const KpiMetrics(
      totalRevenue: 0,
      totalOrdersCount: 0,
      activeProductsCount: 0,
      lowStockCount: 0,
      pendingOrdersCount: 0,
      categoryCount: 0,
    ),
    this.revenueChartData = const RevenueChartData(
      timeframe: ChartTimeframe.weekly,
      spots: [],
      totalRevenueText: '',
      percentageChangeText: '',
      maxX: 6,
      maxY: 10000,
      horizontalInterval: 2500,
    ),
    this.categories = const [],
    this.recentOrders = const [],
    this.inventoryAlerts = const [],
    this.errorMessage,
  });

  final DashboardOverviewStatus status;
  final KpiMetrics kpiMetrics;
  final RevenueChartData revenueChartData;
  final List<CategoryBreakdownItem> categories;
  final List<OrderModel> recentOrders;
  final List<ProductModel> inventoryAlerts;
  final String? errorMessage;

  DashboardOverviewState copyWith({
    DashboardOverviewStatus? status,
    KpiMetrics? kpiMetrics,
    RevenueChartData? revenueChartData,
    List<CategoryBreakdownItem>? categories,
    List<OrderModel>? recentOrders,
    List<ProductModel>? inventoryAlerts,
    String? errorMessage,
  }) {
    return DashboardOverviewState(
      status: status ?? this.status,
      kpiMetrics: kpiMetrics ?? this.kpiMetrics,
      revenueChartData: revenueChartData ?? this.revenueChartData,
      categories: categories ?? this.categories,
      recentOrders: recentOrders ?? this.recentOrders,
      inventoryAlerts: inventoryAlerts ?? this.inventoryAlerts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    kpiMetrics,
    revenueChartData,
    categories,
    recentOrders,
    inventoryAlerts,
    errorMessage,
  ];
}
