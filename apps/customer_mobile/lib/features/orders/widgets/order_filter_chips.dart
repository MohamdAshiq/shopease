import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Filter tabs for Orders screen
enum OrderFilterType {
  all('All'),
  inProgress('In Progress'),
  delivered('Delivered'),
  cancelled('Cancelled');

  const OrderFilterType(this.label);
  final String label;

  bool matches(OrderModel order) {
    switch (this) {
      case OrderFilterType.all:
        return true;
      case OrderFilterType.inProgress:
        return order.status == 'pending' ||
            order.status == 'processing' ||
            order.status == 'shipped';
      case OrderFilterType.delivered:
        return order.status == 'delivered';
      case OrderFilterType.cancelled:
        return order.status == 'cancelled';
    }
  }
}

class OrderFilterChips extends StatelessWidget {
  const OrderFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onSelected,
    required this.allOrders,
  });

  final OrderFilterType selectedFilter;
  final ValueChanged<OrderFilterType> onSelected;
  final List<OrderModel> allOrders;

  int _countFor(OrderFilterType filter) {
    return allOrders.where(filter.matches).length;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.screenPadding,
        vertical: AppSizes.xs,
      ),
      child: Row(
        children: OrderFilterType.values.map((filter) {
          final isSelected = filter == selectedFilter;
          final count = _countFor(filter);

          return Padding(
            padding: const EdgeInsets.only(right: AppSizes.sm),
            child: ChoiceChip(
              selected: isSelected,
              onSelected: (_) => onSelected(filter),
              backgroundColor: AppColors.background,
              selectedColor: AppColors.primary,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.divider,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filter.label,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: AppSizes.xs + 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.sm - 2,
                      vertical: AppSizes.xs / 2,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.25)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                    child: Text(
                      '$count',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
