import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../constants/dashboard_constants.dart';
import '../../cubits/dashboard_overview_cubit.dart';
import '../../cubits/dashboard_overview_state.dart';
import '../components/dashboard_card.dart';

// Sales and Revenue Trend chart card
class RevenueTrendChartCard extends StatelessWidget {
  const RevenueTrendChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardOverviewCubit, DashboardOverviewState>(
      buildWhen: (prev, curr) => prev.revenueChartData != curr.revenueChartData,
      builder: (context, state) {
        final data = state.revenueChartData;

        return DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with title, metric and timeframe toggle
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: AppSizes.md,
                runSpacing: AppSizes.md,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sales & Revenue Trend',
                        style: AppTextStyles.h3.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSizes.xs),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            data.totalRevenueText,
                            style: AppTextStyles.h2.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: AppSizes.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.sm,
                              vertical: AppSizes.xs / 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusSm,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  IconsaxPlusLinear.arrow_up_1,
                                  size: 12,
                                  color: AppColors.success,
                                ),
                                const SizedBox(width: AppSizes.xs / 2),
                                Text(
                                  data.percentageChangeText,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Timeframe Toggle
                  _ChartTimeframeToggle(
                    selectedTimeframe: data.timeframe,
                    onTimeframeChanged: (tf) {
                      context.read<DashboardOverviewCubit>().changeTimeframe(
                        tf,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.xl),

              // Chart Canvas
              SizedBox(
                height: DashboardConstants.trendChartHeight,
                child: LineChart(
                  _buildLineChartData(data),
                  duration: const Duration(milliseconds: 350),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  LineChartData _buildLineChartData(RevenueChartData data) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: data.horizontalInterval,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.divider,
            strokeWidth: 1,
            dashArray: [6, 4],
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 52,
            interval: data.horizontalInterval,
            getTitlesWidget: (value, meta) {
              if (value % data.horizontalInterval != 0) {
                return const SizedBox.shrink();
              }
              return Text(
                _formatYAxisLabel(value),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (value % 1 != 0) return const SizedBox.shrink();
              final label = _formatXAxisLabel(value.toInt(), data.timeframe);
              if (label.isEmpty) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(top: AppSizes.sm),
                child: Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
          left: BorderSide.none,
          right: BorderSide.none,
          top: BorderSide.none,
        ),
      ),
      minX: 0,
      maxX: data.maxX,
      minY: 0,
      maxY: data.maxY,
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => AppColors.sidebarBackground,
          tooltipPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm,
          ),
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              final formattedPrice =
                  '₹${spot.y.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
              final periodLabel = _formatXAxisLabel(
                spot.x.toInt(),
                data.timeframe,
              );
              return LineTooltipItem(
                '$periodLabel\n$formattedPrice',
                AppTextStyles.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: data.spots,
          isCurved: true,
          curveSmoothness: 0.35,
          color: AppColors.primary,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: AppColors.surface,
                strokeWidth: 2.5,
                strokeColor: AppColors.primary,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.22),
                AppColors.primary.withValues(alpha: 0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  String _formatXAxisLabel(int value, ChartTimeframe timeframe) {
    switch (timeframe) {
      case ChartTimeframe.weekly:
        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        if (value >= 0 && value < days.length) return days[value];
        return '';
      case ChartTimeframe.monthly:
        const weeks = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
        if (value >= 0 && value < weeks.length) return weeks[value];
        return '';
      case ChartTimeframe.yearly:
        const months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        if (value >= 0 && value < months.length) {
          return value % 2 == 0 ? months[value] : '';
        }
        return '';
    }
  }

  String _formatYAxisLabel(double value) {
    if (value == 0) return '₹0';
    if (value >= 1000) {
      final kValue = (value / 1000).toInt();
      return '₹${kValue}k';
    }
    return '₹${value.toInt()}';
  }
}

// Custom Toggle Button
class _ChartTimeframeToggle extends StatelessWidget {
  const _ChartTimeframeToggle({
    required this.selectedTimeframe,
    required this.onTimeframeChanged,
  });

  final ChartTimeframe selectedTimeframe;
  final ValueChanged<ChartTimeframe> onTimeframeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.xs),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTab('Weekly', ChartTimeframe.weekly),
          _buildTab('Monthly', ChartTimeframe.monthly),
          _buildTab('Yearly', ChartTimeframe.yearly),
        ],
      ),
    );
  }

  Widget _buildTab(String label, ChartTimeframe timeframe) {
    final isSelected = selectedTimeframe == timeframe;

    return InkWell(
      onTap: () => onTimeframeChanged(timeframe),
      borderRadius: BorderRadius.circular(AppSizes.radiusSm - 2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.xs + 2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm - 2),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
