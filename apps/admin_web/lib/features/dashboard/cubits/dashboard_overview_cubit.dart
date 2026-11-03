import 'dart:async';

import 'package:shopease_core/shopease_core.dart';

import '../constants/dashboard_constants.dart';
import '../utils/dashboard_metric_calculator.dart';
import 'dashboard_overview_state.dart';

// Cubit managing live dashboard metrics, order trends, and inventory alerts
class DashboardOverviewCubit extends Cubit<DashboardOverviewState> {
  DashboardOverviewCubit({
    ProductRepository? productRepository,
    OrderRepository? orderRepository,
  }) : _productRepository = productRepository ?? FirestoreProductRepository(),
       _orderRepository = orderRepository ?? FirestoreOrderRepository(),
       super(const DashboardOverviewState());

  final ProductRepository _productRepository;
  final OrderRepository _orderRepository;

  StreamSubscription<List<ProductModel>>? _productsSubscription;
  StreamSubscription<List<OrderModel>>? _ordersSubscription;

  List<ProductModel> _cachedProducts = [];
  List<OrderModel> _cachedOrders = [];
  ChartTimeframe _currentTimeframe = ChartTimeframe.weekly;

  // Loads live dashboard overview data
  Future<void> loadDashboard() async {
    emit(state.copyWith(status: DashboardOverviewStatus.loading));

    _productsSubscription?.cancel();
    _ordersSubscription?.cancel();

    _productsSubscription = _productRepository.streamProducts().listen(
      (products) {
        _cachedProducts = products;
        _recomputeOverview();
      },
      onError: (e) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: DashboardOverviewStatus.error,
              errorMessage: e.toString(),
            ),
          );
        }
      },
    );

    _ordersSubscription = _orderRepository.watchAllOrders().listen(
      (orders) {
        _cachedOrders = orders;
        _recomputeOverview();
      },
      onError: (e) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: DashboardOverviewStatus.error,
              errorMessage: e.toString(),
            ),
          );
        }
      },
    );
  }

  void _recomputeOverview() {
    if (isClosed) return;

    final lowStockProducts = _cachedProducts
        .where(
          (product) => product.stock < DashboardConstants.lowStockThreshold,
        )
        .take(4)
        .toList();

    final kpiMetrics = DashboardMetricCalculator.computeKpiMetrics(
      products: _cachedProducts,
      orders: _cachedOrders,
    );

    final categories = DashboardMetricCalculator.computeCategoryBreakdown(
      products: _cachedProducts,
      orders: _cachedOrders,
    );

    final chartData = DashboardMetricCalculator.generateChartData(
      timeframe: _currentTimeframe,
      orders: _cachedOrders,
    );

    emit(
      state.copyWith(
        status: DashboardOverviewStatus.loaded,
        kpiMetrics: kpiMetrics,
        revenueChartData: chartData,
        categories: categories,
        recentOrders: _cachedOrders.take(5).toList(),
        inventoryAlerts: lowStockProducts,
      ),
    );
  }

  void changeTimeframe(ChartTimeframe timeframe) {
    _currentTimeframe = timeframe;
    final chartData = DashboardMetricCalculator.generateChartData(
      timeframe: timeframe,
      orders: _cachedOrders,
    );
    emit(state.copyWith(revenueChartData: chartData));
  }

  @override
  Future<void> close() {
    _productsSubscription?.cancel();
    _ordersSubscription?.cancel();
    return super.close();
  }
}
