import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../../app/routing/admin_route_constants.dart';
import '../../constants/dashboard_constants.dart';
import '../../cubits/dashboard_overview_cubit.dart';
import '../../cubits/dashboard_overview_state.dart';
import '../components/dashboard_card.dart';

// Recent orders table widget for dashboard overview
class RecentOrdersTable extends StatelessWidget {
  const RecentOrdersTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardOverviewCubit, DashboardOverviewState>(
      buildWhen: (prev, curr) => prev.recentOrders != curr.recentOrders,
      builder: (context, state) {
        final recentOrders = state.recentOrders;

        return DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Orders',
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () => context.go(AdminRoutePaths.orders),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: AppSizes.xs,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View All',
                            style: AppTextStyles.labelMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: AppSizes.xs),
                          const Icon(
                            IconsaxPlusLinear.arrow_right_3,
                            size: AppSizes.iconSm - AppSizes.xs,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.lg),

              // Empty State or Table
              if (recentOrders.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.xxl),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          IconsaxPlusLinear.shopping_bag,
                          size: AppSizes.iconLg,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: AppSizes.md),
                        Text(
                          'No recent orders placed yet',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    final tableWidth =
                        constraints.maxWidth < DashboardConstants.minTableWidth
                        ? DashboardConstants.minTableWidth
                        : constraints.maxWidth;

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: tableWidth,
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(2.0),
                            1: FlexColumnWidth(3.4),
                            2: FlexColumnWidth(1.6),
                            3: FlexColumnWidth(1.8),
                            4: FlexColumnWidth(2.6),
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            // Table Header Row
                            TableRow(
                              decoration: const BoxDecoration(
                                color: AppColors.scaffoldBackground,
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColors.divider,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              children: [
                                _buildHeaderCell('ORDER ID'),
                                _buildHeaderCell('CUSTOMER'),
                                _buildHeaderCell('ITEMS'),
                                _buildHeaderCell('TOTAL'),
                                _buildHeaderCell('STATUS'),
                              ],
                            ),

                            // Data Rows
                            ...recentOrders.map((order) {
                              return TableRow(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppColors.divider,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                children: [
                                  // Order ID
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSizes.md,
                                      vertical: AppSizes.md,
                                    ),
                                    child: Text(
                                      '#${order.id.split('-').last}',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),

                                  // Customer Info
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSizes.md,
                                      vertical: AppSizes.md,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          order.customerName,
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        Text(
                                          order.customerEmail,
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                color: AppColors.textSecondary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Item Count
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSizes.md,
                                      vertical: AppSizes.md,
                                    ),
                                    child: Text(
                                      '${order.totalItemCount} ${order.totalItemCount == 1 ? 'item' : 'items'}',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),

                                  // Total Price
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSizes.md,
                                      vertical: AppSizes.md,
                                    ),
                                    child: Text(
                                      order.total.inr,
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),

                                  // Status Badge
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSizes.md,
                                      vertical: AppSizes.md,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: OrderStatusBadge(
                                          status: order.orderStatus,
                                          compact: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.md,
      ),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
