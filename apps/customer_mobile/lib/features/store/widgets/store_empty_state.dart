import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Empty state view
class StoreEmptyState extends StatelessWidget {
  const StoreEmptyState({
    super.key,
    required this.query,
    this.showResetButton = true,
    required this.onReset,
  });

  final String query;
  final bool showResetButton;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: showResetButton
          ? IconsaxPlusLinear.box_search
          : IconsaxPlusLinear.box_add,
      title: showResetButton ? 'No Products Found' : 'No Products Available',
      message: showResetButton
          ? (query.isNotEmpty
                ? 'No results match "$query". Try adjusting your search or filters.'
                : 'No products match the selected category filter.')
          : 'The store catalog is currently empty. Check back soon for new arrivals!',
      action: showResetButton
          ? AppButton.compact(
              onPressed: onReset,
              icon: Icons.refresh_rounded,
              label: 'Reset All Filters',
            )
          : null,
    );
  }
}
