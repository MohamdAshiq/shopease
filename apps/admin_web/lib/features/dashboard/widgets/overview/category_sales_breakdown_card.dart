import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../constants/dashboard_constants.dart';
import '../../cubits/dashboard_overview_cubit.dart';
import '../../cubits/dashboard_overview_state.dart';
import '../components/dashboard_card.dart';

// Interactive Donut Chart
class CategorySalesBreakdownCard extends StatefulWidget {
  const CategorySalesBreakdownCard({super.key});

  @override
  State<CategorySalesBreakdownCard> createState() =>
      _CategorySalesBreakdownCardState();
}

class _CategorySalesBreakdownCardState
    extends State<CategorySalesBreakdownCard> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardOverviewCubit, DashboardOverviewState>(
      buildWhen: (prev, curr) => prev.categories != curr.categories,
      builder: (context, state) {
        final categories = state.categories;

        return DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Category Breakdown',
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: AppSizes.xs / 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                    child: Text(
                      '${categories.length} Categories',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.xl),

              // Donut Chart Centered
              Center(
                child: SizedBox(
                  height: DashboardConstants.donutChartHeight,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection ==
                                            null) {
                                      _touchedIndex = -1;
                                      return;
                                    }
                                    _touchedIndex = pieTouchResponse
                                        .touchedSection!
                                        .touchedSectionIndex;
                                  });
                                },
                          ),
                          sectionsSpace: 3,
                          centerSpaceRadius: 90,
                          startDegreeOffset: -90,
                          sections: List.generate(categories.length, (index) {
                            final item = categories[index];
                            final isTouched = index == _touchedIndex;
                            final radius = isTouched ? 36.0 : 30.0;

                            return PieChartSectionData(
                              color: item.color,
                              value: item.percentage.toDouble(),
                              title: '',
                              radius: radius,
                            );
                          }),
                        ),
                      ),

                      // Center Display
                      _DonutCenterHub(
                        percentageText: _getCenterPercentage(categories),
                        labelText: _getCenterLabel(categories),
                        subText: _getCenterSubText(categories),
                        accentColor: _getCenterColor(categories),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getCenterColor(List<CategoryBreakdownItem> categories) {
    if (_touchedIndex >= 0 && _touchedIndex < categories.length) {
      return categories[_touchedIndex].color;
    }
    return AppColors.textPrimary;
  }

  String _getCenterPercentage(List<CategoryBreakdownItem> categories) {
    if (_touchedIndex >= 0 && _touchedIndex < categories.length) {
      return '${categories[_touchedIndex].percentage}%';
    }
    return '100%';
  }

  String _getCenterLabel(List<CategoryBreakdownItem> categories) {
    if (_touchedIndex >= 0 && _touchedIndex < categories.length) {
      return categories[_touchedIndex].name;
    }
    return 'All Categories';
  }

  String _getCenterSubText(List<CategoryBreakdownItem> categories) {
    if (_touchedIndex >= 0 && _touchedIndex < categories.length) {
      return categories[_touchedIndex].revenue;
    }
    return 'Total Sales';
  }
}

// Center display of the donut chart
class _DonutCenterHub extends StatelessWidget {
  const _DonutCenterHub({
    required this.percentageText,
    required this.labelText,
    required this.subText,
    required this.accentColor,
  });

  final String percentageText;
  final String labelText;
  final String subText;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          percentageText,
          style: AppTextStyles.h2.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: accentColor,
            height: 1.0,
          ),
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          labelText,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          subText,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
