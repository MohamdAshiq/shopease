import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';
import 'order_filter_chips.dart';

// Empty State for Orders screen
class OrderEmptyState extends StatelessWidget {
  const OrderEmptyState({super.key, required this.filter});

  final OrderFilterType filter;

  String get _description {
    switch (filter) {
      case OrderFilterType.all:
        return 'You have not placed any orders yet. Discover our latest items and fill your cart!';
      case OrderFilterType.inProgress:
        return 'You do not have any active orders currently in progress.';
      case OrderFilterType.delivered:
        return 'You do not have any delivered orders yet.';
      case OrderFilterType.cancelled:
        return 'No cancelled orders found.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                IconsaxPlusBold.box,
                size: 56,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              filter == OrderFilterType.all
                  ? 'No Orders Placed Yet'
                  : 'No ${filter.label} Orders',
              style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.xs + 2),
            Text(
              _description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.xl),
            AppButton(
              onPressed: () => context.go(RoutePaths.store),
              label: 'Explore Store',
              icon: IconsaxPlusBold.shop,
            ),
          ],
        ),
      ),
    );
  }
}
