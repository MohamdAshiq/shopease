import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../dashboard/widgets/components/filter_dropdown_chip.dart';
import '../cubits/admin_customers_cubit.dart';
import '../cubits/admin_customers_state.dart';

// Filter & search toolbar for customers management
class CustomerFilterToolbar extends StatefulWidget {
  const CustomerFilterToolbar({super.key});

  @override
  State<CustomerFilterToolbar> createState() => _CustomerFilterToolbarState();
}

class _CustomerFilterToolbarState extends State<CustomerFilterToolbar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminCustomersCubit, AdminCustomersState>(
      listenWhen: (prev, curr) => prev.searchQuery != curr.searchQuery,
      listener: (context, state) {
        if (_searchController.text != state.searchQuery) {
          _searchController.text = state.searchQuery;
        }
      },
      child: BlocBuilder<AdminCustomersCubit, AdminCustomersState>(
        builder: (context, state) {
          final cubit = context.read<AdminCustomersCubit>();

          return Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: AppColors.border, width: 1.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top row: Search input + Sort Dropdown
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 650;

                    if (isMobile) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSearchBar(cubit),
                          const SizedBox(height: AppSizes.sm),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _buildSortDropdown(state, cubit),
                          ),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(child: _buildSearchBar(cubit)),
                        const SizedBox(width: AppSizes.md),
                        _buildSortDropdown(state, cubit),
                      ],
                    );
                  },
                ),

                const SizedBox(height: AppSizes.md),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.divider,
                ),
                const SizedBox(height: AppSizes.sm),

                // Bottom row: Tier Segment Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: CustomerTierFilter.values.map((filter) {
                      final isSelected = state.tierFilter == filter;
                      final count = _getCountForTier(state, filter);

                      return Padding(
                        padding: const EdgeInsets.only(right: AppSizes.sm),
                        child: _buildTierChip(
                          filter: filter,
                          count: count,
                          isSelected: isSelected,
                          onTap: () => cubit.filterByTier(filter),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(AdminCustomersCubit cubit) {
    return AppSearchBar(
      controller: _searchController,
      hintText: 'Search by name, email, phone, city, or state...',
      fillColor: AppColors.surface,
      borderColor: AppColors.border,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      onChanged: cubit.search,
      onClear: () {
        _searchController.clear();
        cubit.search('');
      },
    );
  }

  Widget _buildSortDropdown(
    AdminCustomersState state,
    AdminCustomersCubit cubit,
  ) {
    return FilterDropdownChip<CustomerSortBy>(
      value: state.sortBy,
      isActive: state.sortBy != CustomerSortBy.spendHighToLow,
      items: CustomerSortBy.values.map((s) {
        return DropdownMenuItem(value: s, child: Text(s.label));
      }).toList(),
      onChanged: (val) {
        if (val != null) cubit.changeSort(val);
      },
    );
  }

  Widget _buildTierChip({
    required CustomerTierFilter filter,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final Color accentColor = switch (filter) {
      CustomerTierFilter.all => AppColors.primary,
      CustomerTierFilter.vip => AppColors.primary,
      CustomerTierFilter.active => AppColors.success,
      CustomerTierFilter.newCustomer => AppColors.warning,
      CustomerTierFilter.inactive => AppColors.textSecondary,
    };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.1)
              : AppColors.scaffoldBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          border: Border.all(
            color: isSelected ? accentColor : AppColors.border,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              filter.label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isSelected ? accentColor : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            const SizedBox(width: AppSizes.xs + AppSizes.xxs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.xs + AppSizes.xxs,
                vertical: AppSizes.xxs / 2,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? accentColor
                    : AppColors.textSecondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              child: Text(
                count.toString(),
                style: AppTextStyles.badge.copyWith(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getCountForTier(AdminCustomersState state, CustomerTierFilter filter) {
    switch (filter) {
      case CustomerTierFilter.all:
        return state.totalCustomersCount;
      case CustomerTierFilter.vip:
        return state.vipCount;
      case CustomerTierFilter.active:
        return state.activeBuyersCount;
      case CustomerTierFilter.newCustomer:
        return state.newCount;
      case CustomerTierFilter.inactive:
        return state.inactiveCount;
    }
  }
}
