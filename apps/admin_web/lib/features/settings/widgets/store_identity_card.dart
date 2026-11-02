import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../dashboard/constants/dashboard_constants.dart';
import '../../dashboard/widgets/components/dashboard_card.dart';
import '../cubits/admin_settings_cubit.dart';
import '../cubits/admin_settings_state.dart';
import 'edit_store_profile_dialog.dart';

// Store profile and identity display card
class StoreIdentityCard extends StatelessWidget {
  const StoreIdentityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminSettingsCubit, AdminSettingsState>(
      builder: (context, state) {
        return DashboardCard(
          padding: const EdgeInsets.all(AppSizes.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Title and Edit Icon Button
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSizes.sm),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: const Icon(
                      IconsaxPlusLinear.shop,
                      color: AppColors.primary,
                      size: AppSizes.iconMd,
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Store Profile & Identity',
                          style: AppTextStyles.h3,
                        ),
                        const SizedBox(height: AppSizes.xxs),
                        Text(
                          'Public store name, customer support contacts, and localization',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),

                  // Edit Icon Button
                  Tooltip(
                    message: 'Edit Store Profile',
                    child: InkWell(
                      onTap: () => EditStoreProfileDialog.show(context),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      child: Container(
                        padding: const EdgeInsets.all(AppSizes.sm),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusSm,
                          ),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.18),
                          ),
                        ),
                        child: const Icon(
                          IconsaxPlusLinear.edit,
                          color: AppColors.primary,
                          size: AppSizes.iconSm + 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
              const Divider(height: 1, thickness: 1, color: AppColors.divider),
              const SizedBox(height: AppSizes.lg),

              // Store Brand Name Info Tile
              _buildInfoTile(
                icon: IconsaxPlusLinear.shop,
                label: 'Store Brand Name',
                value: state.storeName,
              ),
              const SizedBox(height: AppSizes.md),

              // Customer Contacts Row
              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile =
                      constraints.maxWidth <
                      DashboardConstants.mobileBreakpoint;

                  final emailTile = _buildInfoTile(
                    icon: IconsaxPlusLinear.sms,
                    label: 'Customer Support Email',
                    value: state.supportEmail,
                  );

                  final phoneTile = _buildInfoTile(
                    icon: IconsaxPlusLinear.call,
                    label: 'Contact Support Phone',
                    value: state.phone,
                  );

                  if (isMobile) {
                    return Column(
                      children: [
                        emailTile,
                        const SizedBox(height: AppSizes.md),
                        phoneTile,
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: emailTile),
                      const SizedBox(width: AppSizes.md),
                      Expanded(child: phoneTile),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSizes.md),

              // Regional Information Row
              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile =
                      constraints.maxWidth <
                      DashboardConstants.mobileBreakpoint;

                  final currencyTile = _buildInfoTile(
                    icon: IconsaxPlusLinear.money_tick,
                    label: 'Base Currency',
                    value: state.currency,
                  );

                  final timezoneTile = _buildInfoTile(
                    icon: IconsaxPlusLinear.clock,
                    label: 'Operating Timezone',
                    value: state.timezone,
                  );

                  if (isMobile) {
                    return Column(
                      children: [
                        currencyTile,
                        const SizedBox(height: AppSizes.md),
                        timezoneTile,
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: currencyTile),
                      const SizedBox(width: AppSizes.md),
                      Expanded(child: timezoneTile),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: Row(
        children: [
          Icon(icon, size: AppSizes.iconMd - 2, color: AppColors.textSecondary),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  value,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
