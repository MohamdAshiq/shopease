import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease_core/shopease_core.dart';

import '../cubits/store_cubit.dart';

// Horizontally scrollable category filter chips
class StoreCategoryChips extends StatefulWidget {
  const StoreCategoryChips({super.key});

  @override
  State<StoreCategoryChips> createState() => _StoreCategoryChipsState();
}

class _StoreCategoryChipsState extends State<StoreCategoryChips> {
  final Map<String, GlobalKey> _chipKeys = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final currentCategory = context
            .read<StoreCubit>()
            .state
            .selectedCategory;
        _scrollToCategory(currentCategory);
      }
    });
  }

  void _scrollToCategory(String category) {
    final key = _chipKeys[category];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        alignment: 0.5,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreCubit, StoreState>(
      listenWhen: (previous, current) =>
          previous.selectedCategory != current.selectedCategory,
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _scrollToCategory(state.selectedCategory);
          }
        });
      },
      buildWhen: (previous, current) =>
          previous.selectedCategory != current.selectedCategory ||
          previous.availableCategories != current.availableCategories,
      builder: (context, state) {
        return SizedBox(
          height: 38,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPadding,
            ),
            child: Row(
              children: state.availableCategories.map((category) {
                final isSelected = category == state.selectedCategory;
                final key = _chipKeys.putIfAbsent(category, () => GlobalKey());

                return Padding(
                  key: key,
                  padding: const EdgeInsets.only(right: AppSizes.sm),
                  child: InkWell(
                    onTap: () =>
                        context.read<StoreCubit>().selectCategory(category),
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.md + 2,
                        vertical: AppSizes.xs + 2,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.scaffoldBackground,
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusFull,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
