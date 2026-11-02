import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../models/customer_view_model.dart';

// Customer Financial Summary Card
class CustomerFinancialSummaryCard extends StatelessWidget {
  const CustomerFinancialSummaryCard({super.key, required this.customer});

  final CustomerViewModel customer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                IconsaxPlusLinear.chart_21,
                size: AppSizes.iconSm,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSizes.xs + 2),
              Text(
                'Purchasing Performance',
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              Expanded(
                child: _buildMetric(
                  'Lifetime Spend (LTV)',
                  customer.lifetimeValue.inr2,
                  isHighlighted: true,
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: _buildMetric(
                  'Total Orders',
                  customer.orderCount.toString(),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm + 2),
          Row(
            children: [
              Expanded(
                child: _buildMetric(
                  'Avg. Order Basket',
                  customer.averageOrderValue.inr2,
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: _buildMetric(
                  'Completed Orders',
                  '${customer.completedOrdersCount} fulfilled',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(
    String label,
    String value, {
    bool isHighlighted = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm + 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSizes.xxs),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.bold,
              color: isHighlighted ? AppColors.primary : AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
