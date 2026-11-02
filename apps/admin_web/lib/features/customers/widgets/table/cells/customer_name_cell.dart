import 'package:admin_web/features/customers/models/customer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:shopease_core/theme/app_colors.dart';
import 'package:shopease_core/theme/app_sizes.dart';
import 'package:shopease_core/theme/app_text_styles.dart';
import 'package:shopease_core/utils/date_formatter.dart';

// Customer avatar, name and joined date cell
class CustomerNameCell extends StatelessWidget {
  const CustomerNameCell({
    super.key,
    required this.customer,
    required this.onSelect,
  });

  final CustomerViewModel customer;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final joinedStr = customer.joinedAt.formattedShortDateTime;

    return InkWell(
      onTap: onSelect,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.md,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 19,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              backgroundImage:
                  customer.avatarUrl != null && customer.avatarUrl!.isNotEmpty
                  ? NetworkImage(customer.avatarUrl!)
                  : null,
              child: customer.avatarUrl == null || customer.avatarUrl!.isEmpty
                  ? Text(
                      customer.initials,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    customer.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSizes.xxs),
                  Text(
                    'Joined $joinedStr',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
