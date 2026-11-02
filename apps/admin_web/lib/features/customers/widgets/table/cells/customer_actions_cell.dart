import 'package:admin_web/features/customers/cubits/admin_customers_cubit.dart';
import 'package:admin_web/features/customers/models/customer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Customer inspect action button cell
class CustomerActionsCell extends StatelessWidget {
  const CustomerActionsCell({
    super.key,
    required this.customer,
    required this.cubit,
  });

  final CustomerViewModel customer;
  final AdminCustomersCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.md,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(
                IconsaxPlusLinear.eye,
                color: AppColors.textSecondary,
                size: AppSizes.iconSm,
              ),
              tooltip: 'View Customer Profile',
              visualDensity: VisualDensity.compact,
              onPressed: () => cubit.selectCustomer(customer.id),
            ),
          ],
        ),
      ),
    );
  }
}
