import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../dashboard/constants/dashboard_constants.dart';
import '../cubits/admin_orders_cubit.dart';
import '../cubits/admin_orders_state.dart';
import '../widgets/details/order_details_drawer.dart';
import '../widgets/order_filter_toolbar.dart';
import '../widgets/order_kpi_summary_strip.dart';
import '../widgets/table/orders_data_table.dart';

// Admin Orders Screen
class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminOrdersCubit()..loadOrders(),
      child: const _OrdersContent(),
    );
  }
}

class _OrdersContent extends StatelessWidget {
  const _OrdersContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminOrdersCubit, AdminOrdersState>(
      builder: (context, state) {
        final cubit = context.read<AdminOrdersCubit>();
        final selectedOrder = state.selectedOrder;

        return LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 650;
            final horizontalPadding = isMobile ? AppSizes.md : AppSizes.xl;
            final drawerWidth =
                constraints.maxWidth <
                    DashboardConstants.orderDetailsDrawerWidth
                ? constraints.maxWidth
                : DashboardConstants.orderDetailsDrawerWidth;

            return Stack(
              children: [
                // Orders List
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: AppSizes.xl,
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // KPI Metric Cards
                      OrderKpiSummaryStrip(),
                      SizedBox(height: AppSizes.xl),

                      // Filter & Search Toolbar
                      OrderFilterToolbar(),
                      SizedBox(height: AppSizes.lg),

                      // Orders Data Table
                      OrdersDataTable(),
                      SizedBox(height: AppSizes.xl),
                    ],
                  ),
                ),

                // Modal Backdrop when drawer is open
                if (selectedOrder != null)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: cubit.closeDetailsDrawer,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        color: AppColors.shadow.withValues(alpha: 0.35),
                      ),
                    ),
                  ),

                // Slide-over Right Inspector Drawer
                if (selectedOrder != null)
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    width: drawerWidth,
                    child: OrderDetailsDrawer(
                      order: selectedOrder,
                      cubit: cubit,
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
