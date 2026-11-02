import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';
import '../../../widgets/app_top_bar.dart';
import '../../checkout/widgets/address_edit_sheet.dart';
import '../cubits/profile_cubit.dart';
import '../cubits/profile_state.dart';
import '../widgets/address_card.dart';
import '../widgets/address_empty_state.dart';

// Shipping Addresses management screen
class ShippingAddressesScreen extends StatelessWidget {
  const ShippingAddressesScreen({super.key});

  void _onAddNewAddress(BuildContext context) async {
    final cubit = context.read<ProfileCubit>();
    final result = await AddressEditBottomSheet.show(
      context,
      isDefault: cubit.state.addresses.isEmpty,
    );

    if (result != null && context.mounted) {
      cubit.addAddress(result.address, makeDefault: result.isDefault);
      AppSnackBar.showSuccess(context, 'New address added successfully');
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
    );

    if (result != null && context.mounted) {
      cubit.updateAddress(index, result.address, makeDefault: result.isDefault);
      AppSnackBar.showSuccess(context, 'Address updated successfully');
    }
  }

  void _onDeleteAddress(BuildContext context, int index) {
    final cubit = context.read<ProfileCubit>();
    if (cubit.state.addresses.length <= 1) {
      AppSnackBar.showError(
        context,
        'You must have at least one delivery address saved.',
      );
      return;
    }
    cubit.deleteAddress(index);
    AppSnackBar.showSuccess(context, 'Address deleted');
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(RoutePaths.home);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: const AppTopBar(title: 'Saved Addresses'),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final addresses = state.addresses;
            final defaultIndex = state.defaultAddressIndex;

            if (addresses.isEmpty) {
              return AddressEmptyState(
                onAddAddress: () {
                  HapticFeedback.lightImpact();
                  _onAddNewAddress(context);
                },
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.screenPadding,
                AppSizes.md,
                AppSizes.screenPadding,
                120,
              ),
              itemCount: addresses.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSizes.md),
              itemBuilder: (context, index) {
                final address = addresses[index];
                final isDefault = index == defaultIndex;
                return AddressCard(
                  key: ValueKey('address_${address.street}_$index'),
                  address: address,
                  isDefault: isDefault,
                  onSetDefault: () {
                    context.read<ProfileCubit>().setDefaultAddress(index);
                    AppSnackBar.showSuccess(context, 'Default address updated');
                  },
                  onEdit: () =>
                      _onEditAddress(context, index, address, isDefault),
                  onDelete: () => _onDeleteAddress(context, index),
                );
              },
            );
          },
        ),
        bottomSheet: BlocBuilder<ProfileCubit, ProfileState>(
          buildWhen: (prev, curr) =>
              (prev.addresses.isEmpty) != (curr.addresses.isEmpty),
          builder: (context, state) {
            if (state.addresses.isEmpty) {
              return const SizedBox.shrink();
            }
            return Container(
              padding: const EdgeInsets.all(AppSizes.screenPadding),
              decoration: BoxDecoration(
                color: AppColors.background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                minimum: const EdgeInsets.only(bottom: AppSizes.md),
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
            );
          },
        ),
      ),
    );
  }
}
