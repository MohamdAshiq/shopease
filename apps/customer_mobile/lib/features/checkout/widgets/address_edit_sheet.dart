import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../widgets/app_button.dart';

// Edit Address Bottom Sheet
class AddressEditBottomSheet extends StatefulWidget {
  const AddressEditBottomSheet({super.key, required this.initialAddress});

  final CustomerAddressModel initialAddress;

  static Future<CustomerAddressModel?> show(
    BuildContext context, {
    required CustomerAddressModel initialAddress,
  }) {
    return showModalBottomSheet<CustomerAddressModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          AddressEditBottomSheet(initialAddress: initialAddress),
    );
  }

  @override
  State<AddressEditBottomSheet> createState() => _AddressEditBottomSheetState();
}

class _AddressEditBottomSheetState extends State<AddressEditBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _streetController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _postalController;

  late final FocusNode _nameFocus;
  late final FocusNode _phoneFocus;
  late final FocusNode _streetFocus;
  late final FocusNode _cityFocus;
  late final FocusNode _stateFocus;
  late final FocusNode _postalFocus;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialAddress.recipientName ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.initialAddress.phone ?? '',
    );
    _streetController = TextEditingController(
      text: widget.initialAddress.street,
    );
    _cityController = TextEditingController(text: widget.initialAddress.city);
    _stateController = TextEditingController(text: widget.initialAddress.state);
    _postalController = TextEditingController(
      text: widget.initialAddress.postalCode,
    );

    _nameFocus = FocusNode();
    _phoneFocus = FocusNode();
    _streetFocus = FocusNode();
    _cityFocus = FocusNode();
    _stateFocus = FocusNode();
    _postalFocus = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalController.dispose();

    _nameFocus.dispose();
    _phoneFocus.dispose();
    _streetFocus.dispose();
    _cityFocus.dispose();
    _stateFocus.dispose();
    _postalFocus.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final updated = widget.initialAddress.copyWith(
      recipientName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      postalCode: _postalController.text.trim(),
      country: widget.initialAddress.country.isNotEmpty
          ? widget.initialAddress.country
          : 'India',
    );

    Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.screenPadding,
        AppSizes.sm + 2,
        AppSizes.screenPadding,
        AppSizes.md + bottomInset,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLg),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle indicator
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.xs + 2),

                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delivery Address',
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      color: AppColors.textSecondary,
                      visualDensity: VisualDensity.compact,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),

                _AddressTextField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _phoneFocus.requestFocus(),
                  label: 'Full Name',
                  icon: IconsaxPlusLinear.user,
                ),
                const SizedBox(height: AppSizes.sm),

                _AddressTextField(
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _streetFocus.requestFocus(),
                  label: 'Phone Number',
                  icon: IconsaxPlusLinear.call,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: AppSizes.sm),

                _AddressTextField(
                  controller: _streetController,
                  focusNode: _streetFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _cityFocus.requestFocus(),
                  label: 'Street / Flat / Building No.',
                  icon: IconsaxPlusLinear.location,
                ),
                const SizedBox(height: AppSizes.sm),

                Row(
                  children: [
                    Expanded(
                      child: _AddressTextField(
                        controller: _cityController,
                        focusNode: _cityFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => _stateFocus.requestFocus(),
                        label: 'City',
                        icon: IconsaxPlusLinear.buildings,
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: _AddressTextField(
                        controller: _stateController,
                        focusNode: _stateFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => _postalFocus.requestFocus(),
                        label: 'State',
                        icon: IconsaxPlusLinear.map_1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),

                _AddressTextField(
                  controller: _postalController,
                  focusNode: _postalFocus,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _onSave(),
                  label: 'PIN Code',
                  icon: IconsaxPlusLinear.code,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppSizes.md + 4),

                AppButton(
                  onPressed: _onSave,
                  label: 'Deliver to this Address',
                  icon: IconsaxPlusBold.tick_circle,
                  isFullWidth: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable text field for address inputs
class _AddressTextField extends StatelessWidget {
  const _AddressTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        isDense: true,
        labelText: label,
        labelStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
        prefixIcon: Icon(icon, size: 18, color: AppColors.textSecondary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.sm,
          vertical: AppSizes.sm + 2,
        ),
      ),
      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
    );
  }
}
