import 'package:fl_chart/fl_chart.dart';
import 'package:shopease_core/shopease_core.dart';

import '../constants/dashboard_constants.dart';
import 'dashboard_overview_state.dart';

class DashboardOverviewCubit extends Cubit<DashboardOverviewState> {
  DashboardOverviewCubit() : super(const DashboardOverviewState());

  // Loads dashboard overview data
  void loadDashboard() {
    emit(state.copyWith(status: DashboardOverviewStatus.loading));

    try {
      // Aggregate KPI Metrics
      final totalRevenue = mockOrders.fold<double>(
        0.0,
        (sum, order) => sum + order.total,
      );
      final pendingOrdersCount = mockOrders
          .where((order) => order.status == 'pending')
          .length;
      final lowStockProducts = mockProducts
          .where(
            (product) => product.stock < DashboardConstants.lowStockThreshold,
          )
          .take(4)
          .toList();
      final categoryCount = AppCategories.items
          .where((item) => item.name != AppCategories.all)
          .length;

      final kpiMetrics = KpiMetrics(
        totalRevenue: totalRevenue,
        totalOrdersCount: mockOrders.length,
        activeProductsCount: mockProducts.length,
        lowStockCount: lowStockProducts.length,
        pendingOrdersCount: pendingOrdersCount,
        categoryCount: categoryCount,
      );

      // default category distribution
      const categories = [
        CategoryBreakdownItem(
          name: 'Electronics',
          percentage: 40,
          revenue: '₹58,200',
          color: DashboardConstants.categoryElectronics,
        ),
        CategoryBreakdownItem(
          name: 'Footwear',
          percentage: 25,
          revenue: '₹36,400',
          color: DashboardConstants.categoryFootwear,
        ),
        CategoryBreakdownItem(
          name: 'Accessories',
          percentage: 18,
          revenue: '₹26,200',
          color: DashboardConstants.categoryAccessories,
        ),
        CategoryBreakdownItem(
          name: 'Gaming',
          percentage: 12,
          revenue: '₹17,500',
          color: DashboardConstants.categoryGaming,
        ),
        CategoryBreakdownItem(
          name: 'Home & Kitchen',
          percentage: 5,
          revenue: '₹7,300',
          color: DashboardConstants.categoryHomeKitchen,
        ),
      ];

      final chartData = _generateChartData(ChartTimeframe.weekly);

      emit(
        state.copyWith(
          status: DashboardOverviewStatus.loaded,
          kpiMetrics: kpiMetrics,
          revenueChartData: chartData,
          categories: categories,
          recentOrders: mockOrders.take(5).toList(),
          inventoryAlerts: lowStockProducts,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DashboardOverviewStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void changeTimeframe(ChartTimeframe timeframe) {
    final chartData = _generateChartData(timeframe);
    emit(state.copyWith(revenueChartData: chartData));
  }

  RevenueChartData _generateChartData(ChartTimeframe timeframe) {
    switch (timeframe) {
      case ChartTimeframe.weekly:
        return const RevenueChartData(
          timeframe: ChartTimeframe.weekly,
          spots: [
            FlSpot(0, 3200),
            FlSpot(1, 4800),
            FlSpot(2, 4100),
            FlSpot(3, 6700),
            FlSpot(4, 5900),
            FlSpot(5, 8400),
            FlSpot(6, 7300),
          ],
          totalRevenueText: '₹34,500',
          percentageChangeText: '+18.4% vs last period',
          maxX: 6,
          maxY: 10000,
          horizontalInterval: 2500,
        );
      case ChartTimeframe.monthly:
        return const RevenueChartData(
          timeframe: ChartTimeframe.monthly,
          spots: [
            FlSpot(0, 24000),
            FlSpot(1, 38000),
            FlSpot(2, 31000),
            FlSpot(3, 49800),
          ],
          totalRevenueText: '₹1,42,800',
          percentageChangeText: '+22.6% vs last period',
          maxX: 3,
          maxY: 50000,
          horizontalInterval: 12500,
        );
      case ChartTimeframe.yearly:
        return const RevenueChartData(
          timeframe: ChartTimeframe.yearly,
          spots: [
            FlSpot(0, 65000),
            FlSpot(1, 72000),
            FlSpot(2, 89000),
            FlSpot(3, 94000),
            FlSpot(4, 110000),
            FlSpot(5, 105000),
            FlSpot(6, 128000),
            FlSpot(7, 134000),
            FlSpot(8, 142000),
            FlSpot(9, 155000),
            FlSpot(10, 168000),
            FlSpot(11, 185000),
          ],
          totalRevenueText: '₹12,85,000',
          percentageChangeText: '+31.2% vs last period',
          maxX: 11,
          maxY: 200000,
          horizontalInterval: 50000,
        );
    }
  }
}
