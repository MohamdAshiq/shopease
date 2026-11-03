import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../dashboard/constants/dashboard_constants.dart';
import '../cubits/admin_customers_cubit.dart';
import '../cubits/admin_customers_state.dart';
import '../widgets/customer_filter_toolbar.dart';
import '../widgets/customer_kpi_summary_strip.dart';
import '../widgets/details/customer_details_drawer.dart';
import '../widgets/table/customers_data_table.dart';

// Admin Customers Management Screen
class AdminCustomersScreen extends StatelessWidget {
  const AdminCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminCustomersCubit()..loadCustomers(),
      child: const _CustomersContent(),
    );
  }
}

class _CustomersContent extends StatelessWidget {
  const _CustomersContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCustomersCubit, AdminCustomersState>(
      builder: (context, state) {
        final cubit = context.read<AdminCustomersCubit>();
        final selectedCustomer = state.selectedCustomer;

        return LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 650;
            final horizontalPadding = isMobile ? AppSizes.md : AppSizes.xl;
            final drawerWidth =
                constraints.maxWidth <
                    DashboardConstants.customerDetailsDrawerWidth
                ? constraints.maxWidth
                : DashboardConstants.customerDetailsDrawerWidth;

            return Stack(
              children: [
                // Customers List & Controls
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: AppSizes.xl,
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // KPI Metric Cards
                      CustomerKpiSummaryStrip(),
                      SizedBox(height: AppSizes.xl),

                      // Filter & Search Toolbar
                      CustomerFilterToolbar(),
                      SizedBox(height: AppSizes.lg),

                      // Customers Data Table
                      CustomersDataTable(),
                      SizedBox(height: AppSizes.xl),
                    ],
                  ),
                ),

                // Modal Backdrop when drawer is open
                if (selectedCustomer != null)
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
                if (selectedCustomer != null)
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    width: drawerWidth,
                    child: CustomerDetailsDrawer(
                      customer: selectedCustomer,
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
