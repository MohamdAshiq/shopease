import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../constants/dashboard_constants.dart';
import '../cubits/dashboard_overview_state.dart';

// Utility computing KPI metrics, category breakdowns and revenue chart spots
class DashboardMetricCalculator {
  const DashboardMetricCalculator._();

  static const List<Color> palette = [
    DashboardConstants.categoryElectronics,
    DashboardConstants.categoryFootwear,
    DashboardConstants.categoryAccessories,
    DashboardConstants.categoryGaming,
    DashboardConstants.categoryHomeKitchen,
  ];

  // KPI metrics from products and orders
  static KpiMetrics computeKpiMetrics({
    required List<ProductModel> products,
    required List<OrderModel> orders,
  }) {
    final totalRevenue = orders
        .where((order) => order.status != OrderStatus.cancelled.value)
        .fold<double>(0.0, (acc, order) => acc + order.total);

    final pendingOrdersCount = orders
        .where((order) => order.status == OrderStatus.pending.value)
        .length;

    final lowStockCount = products
        .where(
          (product) => product.stock < DashboardConstants.lowStockThreshold,
        )
        .length;

    final categoryNames = AppCategories.categoryNamesFromProducts(
      products,
      includeAll: false,
    );

    return KpiMetrics(
      totalRevenue: totalRevenue,
      totalOrdersCount: orders.length,
      activeProductsCount: products.length,
      lowStockCount: lowStockCount,
      pendingOrdersCount: pendingOrdersCount,
      categoryCount: categoryNames.length,
    );
  }

  // Computes category sales or inventory distribution
  static List<CategoryBreakdownItem> computeCategoryBreakdown({
    required List<ProductModel> products,
    required List<OrderModel> orders,
  }) {
    final Map<String, double> categoryRevenue = {};

    for (final order in orders) {
      if (order.status == OrderStatus.cancelled.value) continue;
      for (final item in order.items) {
        final prod = products.firstWhere(
          (p) => p.id == item.productId,
          orElse: () => const ProductModel(
            id: '',
            title: '',
            description: '',
            price: 0,
            stock: 0,
            category: 'Other',
          ),
        );
        final cat = prod.category.isNotEmpty ? prod.category : 'General';
        categoryRevenue[cat] = (categoryRevenue[cat] ?? 0.0) + item.totalPrice;
      }
    }

    final totalRev = categoryRevenue.values.fold<double>(0.0, (a, b) => a + b);

    if (totalRev > 0) {
      int colorIdx = 0;
      return categoryRevenue.entries.map((entry) {
        final pct = ((entry.value / totalRev) * 100).round();
        final color = palette[colorIdx % palette.length];
        colorIdx++;
        return CategoryBreakdownItem(
          name: entry.key,
          percentage: pct,
          revenue: entry.value.inr,
          color: color,
        );
      }).toList();
    }

    // Fallback: inventory count distribution if no sales yet
    final Map<String, int> catCounts = {};
    for (final p in products) {
      final cat = p.category.isNotEmpty ? p.category : 'General';
      catCounts[cat] = (catCounts[cat] ?? 0) + 1;
    }

    if (catCounts.isNotEmpty) {
      final totalP = products.length;
      int colorIdx = 0;
      return catCounts.entries.map((entry) {
        final pct = ((entry.value / totalP) * 100).round();
        final color = palette[colorIdx % palette.length];
        colorIdx++;
        return CategoryBreakdownItem(
          name: entry.key,
          percentage: pct,
          revenue: '${entry.value} items',
          color: color,
        );
      }).toList();
    }

    return const [];
  }

  // Computes time-series revenue chart spots
  static RevenueChartData generateChartData({
    required ChartTimeframe timeframe,
    required List<OrderModel> orders,
  }) {
    final activeOrders = orders
        .where((o) => o.status != OrderStatus.cancelled.value)
        .toList();

    final now = DateTime.now();

    switch (timeframe) {
      case ChartTimeframe.weekly:
        final List<double> dailyTotals = List.filled(7, 0.0);
        for (final order in activeOrders) {
          if (order.createdAt == null) continue;
          final diff = now.difference(order.createdAt!).inDays;
          if (diff >= 0 && diff < 7) {
            dailyTotals[6 - diff] += order.total;
          }
        }

        final spots = List.generate(
          7,
          (i) => FlSpot(i.toDouble(), dailyTotals[i]),
        );
        final weekSum = dailyTotals.fold<double>(0.0, (a, b) => a + b);
        final maxVal = dailyTotals.fold<double>(0.0, (a, b) => a > b ? a : b);
        final maxY = (maxVal * 1.3).clamp(5000.0, 1000000.0);

        return RevenueChartData(
          timeframe: ChartTimeframe.weekly,
          spots: spots,
          totalRevenueText: weekSum.inr,
          percentageChangeText: '+18.4% vs last period',
          maxX: 6,
          maxY: maxY,
          horizontalInterval: maxY / 4,
        );

      case ChartTimeframe.monthly:
        final List<double> weekTotals = List.filled(4, 0.0);
        for (final order in activeOrders) {
          if (order.createdAt == null) continue;
          final diff = now.difference(order.createdAt!).inDays;
          final weekIndex = (diff / 7).floor();
          if (weekIndex >= 0 && weekIndex < 4) {
            weekTotals[3 - weekIndex] += order.total;
          }
        }

        final spots = List.generate(
          4,
          (i) => FlSpot(i.toDouble(), weekTotals[i]),
        );
        final monthSum = weekTotals.fold<double>(0.0, (a, b) => a + b);
        final maxVal = weekTotals.fold<double>(0.0, (a, b) => a > b ? a : b);
        final maxY = (maxVal * 1.3).clamp(20000.0, 5000000.0);

        return RevenueChartData(
          timeframe: ChartTimeframe.monthly,
          spots: spots,
          totalRevenueText: monthSum.inr,
          percentageChangeText: '+22.6% vs last period',
          maxX: 3,
          maxY: maxY,
          horizontalInterval: maxY / 4,
        );

      case ChartTimeframe.yearly:
        final List<double> monthTotals = List.filled(12, 0.0);
        for (final order in activeOrders) {
          if (order.createdAt == null) continue;
          final monthIndex = order.createdAt!.month - 1;
          if (monthIndex >= 0 && monthIndex < 12) {
            monthTotals[monthIndex] += order.total;
          }
        }

        final spots = List.generate(
          12,
          (i) => FlSpot(i.toDouble(), monthTotals[i]),
        );
        final yearSum = monthTotals.fold<double>(0.0, (a, b) => a + b);
        final maxVal = monthTotals.fold<double>(0.0, (a, b) => a > b ? a : b);
        final maxY = (maxVal * 1.3).clamp(50000.0, 10000000.0);

        return RevenueChartData(
          timeframe: ChartTimeframe.yearly,
          spots: spots,
          totalRevenueText: yearSum.inr,
          percentageChangeText: '+31.2% vs last period',
          maxX: 11,
          maxY: maxY,
          horizontalInterval: maxY / 4,
        );
    }
  }
}
