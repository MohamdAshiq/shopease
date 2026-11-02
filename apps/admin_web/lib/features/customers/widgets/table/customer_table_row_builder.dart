import 'package:admin_web/features/customers/widgets/table/cells/customer_actions_cell.dart';
import 'package:admin_web/features/customers/widgets/table/cells/customer_contact_cell.dart';
import 'package:admin_web/features/customers/widgets/table/cells/customer_ltv_cell.dart';
import 'package:admin_web/features/customers/widgets/table/cells/customer_name_cell.dart';
import 'package:admin_web/features/customers/widgets/table/cells/customer_orders_cell.dart';
import 'package:admin_web/features/customers/widgets/table/cells/customer_tier_cell.dart';
import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../cubits/admin_customers_cubit.dart';
import '../../models/customer_view_model.dart';
import 'cells/customer_header_cells.dart';

// Builder for Customers Table header and data rows.
abstract final class CustomerTableRowBuilder {
  static TableRow buildHeader() {
    return const TableRow(
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1.0),
        ),
      ),
      children: [
        CustomerHeaderCell('CUSTOMER'),
        CustomerHeaderCell('CONTACT'),
        CustomerHeaderCell('ORDERS'),
        CustomerHeaderCell('TOTAL SPEND (LTV)'),
        CustomerHeaderCell('TIER'),
        CustomerHeaderCell('ACTIONS', alignRight: true),
      ],
    );
  }

  static TableRow buildRow({
    required BuildContext context,
    required CustomerViewModel customer,
    required AdminCustomersCubit cubit,
    required bool isSelected,
    required bool isEven,
  }) {
    final bgColor = isSelected
        ? AppColors.primary.withValues(alpha: 0.06)
        : isEven
        ? AppColors.surface
        : AppColors.scaffoldBackground.withValues(alpha: 0.5);

    return TableRow(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          bottom: const BorderSide(color: AppColors.divider, width: 0.8),
          left: isSelected
              ? const BorderSide(color: AppColors.primary, width: 3.0)
              : BorderSide.none,
        ),
      ),
      children: [
        CustomerNameCell(
          customer: customer,
          onSelect: () => cubit.selectCustomer(customer.id),
        ),
        CustomerContactCell(customer: customer),
        CustomerOrdersCell(customer: customer),
        CustomerLtvCell(customer: customer),
        CustomerTierCell(customer: customer),
        CustomerActionsCell(customer: customer, cubit: cubit),
      ],
    );
  }
}
