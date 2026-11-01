import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Vertical timeline for tracking order status
class OrderTimeline extends StatelessWidget {
  const OrderTimeline({super.key, required this.order});

  final OrderModel order;

  static const _stages = [
    OrderStatus.pending,
    OrderStatus.processing,
    OrderStatus.shipped,
    OrderStatus.delivered,
  ];

  @override
  Widget build(BuildContext context) {
    final isCancelled = order.orderStatus == OrderStatus.cancelled;
    final currentStatusIndex = order.orderStatus.stepIndex;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionCardHeader(
            icon: IconsaxPlusBold.routing,
            title: 'Tracking Status',
          ),

          if (isCancelled) ...[
            Container(
              padding: const EdgeInsets.all(AppSizes.sm + 2),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Row(
                children: [
                  const Icon(
                    IconsaxPlusBold.close_circle,
                    color: AppColors.error,
                    size: 20,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Cancelled',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'This order was cancelled and will not be delivered.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            for (int index = 0; index < _stages.length; index++)
              _buildTimelineStage(index, currentStatusIndex),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineStage(int index, int currentStatusIndex) {
    final stage = _stages[index];
    final isPassed = currentStatusIndex >= index;
    final isCurrent = currentStatusIndex == index;
    final isLast = index == _stages.length - 1;

    final historyItem = order.statusHistory
        .where((h) => h.status.toLowerCase() == stage.name)
        .firstOrNull;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicator column with line
          Column(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isPassed
                      ? (isCurrent ? AppColors.primary : AppColors.success)
                      : AppColors.divider,
                ),
                child: Icon(
                  isPassed ? Icons.check : Icons.circle,
                  size: isPassed ? 11 : 6,
                  color: isPassed ? Colors.white : AppColors.textSecondary,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isPassed && currentStatusIndex > index
                        ? AppColors.success
                        : AppColors.divider,
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSizes.md),

          // Status Description Column
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSizes.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stage.timelineTitle,
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: isCurrent
                          ? FontWeight.w700
                          : (isPassed ? FontWeight.w600 : FontWeight.w400),
                      color: isPassed
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                  if (historyItem != null) ...[
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      historyItem.timestamp.formattedDateTime,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
