import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';

class AddressEditResult {
  const AddressEditResult({required this.address, this.isDefault = false});

  final CustomerAddressModel address;
  final bool isDefault;
}

// Edit or Add Address Bottom Sheet
class AddressEditBottomSheet extends StatefulWidget {
  const AddressEditBottomSheet({
    super.key,
    this.initialAddress,
    this.isDefault = false,
    this.showDefaultToggle = true,
    this.title,
    this.submitButtonLabel,
  });

  final CustomerAddressModel? initialAddress;
  final bool isDefault;
  final bool showDefaultToggle;
  final String? title;
  final String? submitButtonLabel;

  static Future<AddressEditResult?> show(
    BuildContext context, {
    CustomerAddressModel? initialAddress,
    bool isDefault = false,
    bool showDefaultToggle = true,
    String? title,
    String? submitButtonLabel,
  }) {
    return showModalBottomSheet<AddressEditResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddressEditBottomSheet(
        initialAddress: initialAddress,
        isDefault: isDefault,
        showDefaultToggle: showDefaultToggle,
        title: title,
        submitButtonLabel: submitButtonLabel,
      ),
    );
  }

  @override
  State<AddressEditBottomSheet> createState() => _AddressEditBottomSheetState();
}

class _AddressEditBottomSheetState extends State<AddressEditBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late String _selectedTag;
  late bool _isDefault;

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

  static const List<(String, IconData)> _tags = [
    ('Home', IconsaxPlusLinear.home),
    ('Work', IconsaxPlusLinear.briefcase),
    ('Other', IconsaxPlusLinear.location),
  ];

  @override
  void initState() {
    super.initState();
    _selectedTag = widget.initialAddress?.label ?? 'Home';
    _isDefault = widget.isDefault;

    _nameController = TextEditingController(
      text: widget.initialAddress?.recipientName ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.initialAddress?.phone ?? '',
    );
    _streetController = TextEditingController(
      text: widget.initialAddress?.street ?? '',
    );
    _cityController = TextEditingController(
      text: widget.initialAddress?.city ?? '',
    );
    _stateController = TextEditingController(
      text: widget.initialAddress?.state ?? '',
    );
    _postalController = TextEditingController(
      text: widget.initialAddress?.postalCode ?? '',
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
    HapticFeedback.lightImpact();

    final address = widget.initialAddress != null
        ? widget.initialAddress!.copyWith(
            recipientName: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            street: _streetController.text.trim(),
            city: _cityController.text.trim(),
            state: _stateController.text.trim(),
            postalCode: _postalController.text.trim(),
            label: _selectedTag,
          )
        : CustomerAddressModel(
            recipientName: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            street: _streetController.text.trim(),
            city: _cityController.text.trim(),
            state: _stateController.text.trim(),
            postalCode: _postalController.text.trim(),
            country: 'India',
            label: _selectedTag,
          );

    Navigator.of(context)
        .pop(AddressEditResult(address: address, isDefault: _isDefault));
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isEditing = widget.initialAddress != null;
    final defaultTitle = isEditing ? 'Edit Address' : 'Add New Address';
    final defaultButtonLabel = isEditing ? 'Save Changes' : 'Save Address';

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
                    height: AppSizes.xs,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(AppSizes.xs / 2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.xs + 2),

                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title ?? defaultTitle,
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
                const SizedBox(height: AppSizes.md),

                // Address Type / Tag Chips
                Text(
                  'Address Type',
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSizes.xs + 2),
                Row(
                  children: [
                    for (final (tag, icon) in _tags) ...[
                      ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icon,
                              size: AppSizes.iconSm - 2,
                              color: _selectedTag == tag
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(width: AppSizes.xs + 2),
                            Text(tag),
                          ],
                        ),
                        selected: _selectedTag == tag,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        showCheckmark: false,
                        labelStyle: AppTextStyles.labelSmall.copyWith(
                          color: _selectedTag == tag
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontWeight: _selectedTag == tag
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusSm,
                          ),
                          side: BorderSide(
                            color: _selectedTag == tag
                                ? AppColors.primary
                                : AppColors.divider,
                          ),
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            HapticFeedback.lightImpact();
                            setState(() => _selectedTag = tag);
                          }
                        },
                      ),
                      const SizedBox(width: AppSizes.sm),
                    ],
                  ],
                ),
                const SizedBox(height: AppSizes.md),

                // Full Name
                AppTextField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _phoneFocus.requestFocus(),
                  label: 'Full Name',
                  hintText: 'e.g. Alex Morgan',
                  prefixIcon: IconsaxPlusLinear.user,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: AppSizes.sm),

                // Phone Number
                AppTextField(
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _streetFocus.requestFocus(),
                  label: 'Phone Number',
                  hintText: 'e.g. +91 98765 43210',
                  prefixIcon: IconsaxPlusLinear.call,
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: AppSizes.sm),

                // Street
                AppTextField(
                  controller: _streetController,
                  focusNode: _streetFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _cityFocus.requestFocus(),
                  label: 'Street / Flat / House No.',
                  hintText: 'e.g. Flat 402, Lotus Residency, MG Road',
                  prefixIcon: IconsaxPlusLinear.location,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: AppSizes.sm),

                // City & State
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _cityController,
                        focusNode: _cityFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => _stateFocus.requestFocus(),
                        label: 'City',
                        hintText: 'e.g. Bengaluru',
                        prefixIcon: IconsaxPlusLinear.buildings,
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: AppTextField(
                        controller: _stateController,
                        focusNode: _stateFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => _postalFocus.requestFocus(),
                        label: 'State',
                        hintText: 'e.g. Karnataka',
                        prefixIcon: IconsaxPlusLinear.map_1,
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),

                // PIN Code
                AppTextField(
                  controller: _postalController,
                  focusNode: _postalFocus,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _onSave(),
                  label: 'PIN Code',
                  hintText: 'e.g. 560001',
                  prefixIcon: IconsaxPlusLinear.code,
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),

                // Default Address toggle switch
                if (widget.showDefaultToggle) ...[
                  const SizedBox(height: AppSizes.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: AppSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(
                        color: AppColors.divider.withValues(alpha: 0.8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Set as default address',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: AppSizes.xs / 2),
                              Text(
                                'Primary address for checkout delivery',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch.adaptive(
                          value: _isDefault,
                          activeThumbColor: AppColors.primary,
                          onChanged: (val) {
                            HapticFeedback.lightImpact();
                            setState(() => _isDefault = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppSizes.lg),

                AppButton(
                  onPressed: _onSave,
                  label: widget.submitButtonLabel ?? defaultButtonLabel,
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
