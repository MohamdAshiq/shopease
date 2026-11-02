import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';
import '../../../widgets/app_top_bar.dart';
import '../cubits/order_cubit.dart';
import '../cubits/order_state.dart';
import '../widgets/order_card.dart';
import '../widgets/order_empty_state.dart';
import '../widgets/order_filter_chips.dart';

// Customer Order History Screen
class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  OrderFilterType _selectedFilter = OrderFilterType.all;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(RoutePaths.home);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: const AppTopBar(title: 'My Orders'),
        body: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            final allOrders = state.orders;
            final filteredOrders = allOrders
                .where(_selectedFilter.matches)
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter Chips
                Container(
                  color: AppColors.background,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSizes.xs + 2,
                  ),
                  child: OrderFilterChips(
                    selectedFilter: _selectedFilter,
                    onSelected: (filter) {
                      setState(() => _selectedFilter = filter);
                    },
                    allOrders: allOrders,
                  ),
                ),
                const Divider(height: 1, color: AppColors.divider),

                // Orders List or Empty State
                Expanded(
                  child: filteredOrders.isEmpty
                      ? OrderEmptyState(filter: _selectedFilter)
                      : ListView.separated(
                          padding: const EdgeInsets.all(AppSizes.screenPadding),
                          itemCount: filteredOrders.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSizes.md),
                          itemBuilder: (context, index) {
                            final order = filteredOrders[index];
                            return OrderCard(
                              key: ValueKey(order.id),
                              order: order,
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
