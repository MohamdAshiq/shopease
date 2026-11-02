import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../cubits/admin_customers_cubit.dart';
import '../../models/customer_view_model.dart';
import 'customer_contact_address_card.dart';
import 'customer_financial_summary_card.dart';
import 'customer_orders_history_card.dart';

// Customer Details Drawer
class CustomerDetailsDrawer extends StatelessWidget {
  const CustomerDetailsDrawer({
    super.key,
    required this.customer,
    required this.cubit,
  });

  final CustomerViewModel customer;
  final AdminCustomersCubit cubit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 460;

        return Container(
          width: constraints.maxWidth,
          height: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: isMobile
                ? null
                : const Border(
                    left: BorderSide(color: AppColors.border, width: 1.0),
                  ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.16),
                blurRadius: 32,
                offset: const Offset(-4, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drawer Header
              _buildHeader(context, isMobile),

              // Scrollable Detail Cards
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? AppSizes.md : AppSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Purchasing Performance
                      CustomerFinancialSummaryCard(customer: customer),
                      const SizedBox(height: AppSizes.md),

                      // Order History
                      CustomerOrdersHistoryCard(customer: customer),
                      const SizedBox(height: AppSizes.md),

                      // Contact & Shipping Address
                      CustomerContactAddressCard(customer: customer),
                      const SizedBox(height: AppSizes.xl),
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

  Widget _buildHeader(BuildContext context, bool isMobile) {
    final tier = customer.tier;
    final joinedStr = customer.joinedAt.formattedShortDateTime;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? AppSizes.md : AppSizes.xl,
        vertical: isMobile ? AppSizes.md : AppSizes.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1.0),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            backgroundImage:
                customer.avatarUrl != null && customer.avatarUrl!.isNotEmpty
                ? NetworkImage(customer.avatarUrl!)
                : null,
            child: customer.avatarUrl == null || customer.avatarUrl!.isEmpty
                ? Text(
                    customer.initials,
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        customer.name,
                        style: AppTextStyles.h3.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: AppSizes.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: tier.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusFull,
                        ),
                        border: Border.all(
                          color: tier.color.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        tier.label,
                        style: AppTextStyles.badge.copyWith(color: tier.color),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.xxs),
                Text(
                  'Member since $joinedStr',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              IconsaxPlusLinear.close_circle,
              color: AppColors.textSecondary,
              size: AppSizes.iconMd,
            ),
            tooltip: 'Close Profile',
            onPressed: cubit.closeDetailsDrawer,
          ),
        ],
      ),
    );
  }
}
