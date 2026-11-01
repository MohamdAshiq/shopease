import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../widgets/app_button.dart';
import '../../profile/cubits/profile_cubit.dart';
import '../../profile/cubits/profile_state.dart';
import 'address_edit_sheet.dart';
import 'address_selection_tile.dart';

// Address Selection Sheet
class AddressSelectionSheet extends StatelessWidget {
  const AddressSelectionSheet({super.key, required this.selectedAddress});

  final CustomerAddressModel selectedAddress;

  static Future<CustomerAddressModel?> show(
    BuildContext context, {
    required CustomerAddressModel selectedAddress,
  }) {
    return showModalBottomSheet<CustomerAddressModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<ProfileCubit>(),
        child: AddressSelectionSheet(selectedAddress: selectedAddress),
      ),
    );
  }

  void _onAddNewAddress(BuildContext context) async {
    final cubit = context.read<ProfileCubit>();
    final result = await AddressEditBottomSheet.show(
      context,
      isDefault: cubit.state.addresses.isEmpty,
      title: 'Add New Address',
      submitButtonLabel: 'Save & Deliver Here',
    );

    if (result != null && context.mounted) {
      cubit.addAddress(result.address, makeDefault: result.isDefault);
      Navigator.of(context).pop(result.address);
    }
  }

  void _onEditAddress(
    BuildContext context,
    int index,
    CustomerAddressModel address,
    bool isDefault,
  ) async {
    final cubit = context.read<ProfileCubit>();
    final result = await AddressEditBottomSheet.show(
      context,
      initialAddress: address,
      isDefault: isDefault,
      title: 'Edit Address',
      submitButtonLabel: 'Save Changes',
    );

    if (result != null && context.mounted) {
      cubit.updateAddress(index, result.address, makeDefault: result.isDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        final addresses = profileState.addresses;
        final defaultIndex = profileState.defaultAddressIndex;

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSizes.radiusLg),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top handle
                const SizedBox(height: AppSizes.sm),
                Center(
                  child: Container(
                    width: 36,
                    height: AppSizes.xs,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(AppSizes.xs / 2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.xs + 2),

                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Delivery Address',
                        style: AppTextStyles.h3.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          size: AppSizes.iconSm + AppSizes.xs,
                        ),
                        color: AppColors.textSecondary,
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.divider),

                // List of addresses or empty state
                Flexible(
                  child: addresses.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(AppSizes.xl),
                          child: Center(
                            child: Text(
                              'No saved addresses found.\nAdd a new address below.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.screenPadding,
                            vertical: AppSizes.md,
                          ),
                          itemCount: addresses.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSizes.sm + 2),
                          itemBuilder: (context, index) {
                            final address = addresses[index];
                            final isSelected =
                                address.street == selectedAddress.street &&
                                address.postalCode ==
                                    selectedAddress.postalCode &&
                                address.recipientName ==
                                    selectedAddress.recipientName;
                            final isDefault = index == defaultIndex;

                            return AddressSelectionTile(
                              key: ValueKey(
                                'sel_addr_${address.street}_$index',
                              ),
                              address: address,
                              isSelected: isSelected,
                              isDefault: isDefault,
                              onTap: () => Navigator.of(context).pop(address),
                              onEdit: () => _onEditAddress(
                                context,
                                index,
                                address,
                                isDefault,
                              ),
                            );
                          },
                        ),
                ),

                // Add New Address button
                Padding(
                  padding: const EdgeInsets.all(AppSizes.screenPadding),
                  child: SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _onAddNewAddress(context);
                      },
                      label: 'Add New Address',
                      icon: IconsaxPlusBold.add,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
