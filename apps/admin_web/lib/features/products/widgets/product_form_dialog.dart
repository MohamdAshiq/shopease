import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../dashboard/constants/dashboard_constants.dart';
import '../cubits/admin_products_cubit.dart';
import 'form/product_availability_tile.dart';
import 'form/product_category_selector.dart';
import 'form/product_image_preview_field.dart';

// Modal dialog for adding or editing a product in the admin panel
class ProductFormDialog extends StatefulWidget {
  const ProductFormDialog({
    super.key,
    this.initialProduct,
    required this.cubit,
  });

  final ProductModel? initialProduct;
  final AdminProductsCubit cubit;

  static Future<void> show(
    BuildContext context, {
    ProductModel? initialProduct,
  }) {
    final cubit = context.read<AdminProductsCubit>();
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          ProductFormDialog(initialProduct: initialProduct, cubit: cubit),
    );
  }

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _descriptionController;

  late String _selectedCategory;
  late bool _isAvailable;

  bool get _isEditing => widget.initialProduct != null;

  @override
  void initState() {
    super.initState();
    final p = widget.initialProduct;
    _titleController = TextEditingController(text: p?.title ?? '');
    _priceController = TextEditingController(
      text: p != null ? p.price.toStringAsFixed(0) : '',
    );
    _stockController = TextEditingController(
      text: p != null ? p.stock.toString() : '20',
    );
    _imageUrlController = TextEditingController(text: p?.primaryImageUrl ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');

    final availableCategories = AppCategories.names
        .where((name) => name != 'All')
        .toList();
    if (p != null && availableCategories.contains(p.category)) {
      _selectedCategory = p.category;
    } else {
      _selectedCategory = availableCategories.first;
    }

    _isAvailable = p?.isAvailable ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final parsedPrice = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final parsedStock = int.tryParse(_stockController.text.trim()) ?? 0;
    final imgUrl = _imageUrlController.text.trim();

    if (_isEditing) {
      final existing = widget.initialProduct!;
      final updated = existing.copyWith(
        title: _titleController.text.trim(),
        category: _selectedCategory,
        price: parsedPrice,
        stock: parsedStock,
        description: _descriptionController.text.trim(),
        imageUrls: imgUrl.isNotEmpty ? [imgUrl] : existing.imageUrls,
        isAvailable: _isAvailable,
        updatedAt: DateTime.now(),
      );
      widget.cubit.updateProduct(updated);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Updated "${updated.title}" successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      final newProduct = ProductModel(
        id: 'PROD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        title: _titleController.text.trim(),
        category: _selectedCategory,
        price: parsedPrice,
        stock: parsedStock,
        description: _descriptionController.text.trim(),
        imageUrls: imgUrl.isNotEmpty ? [imgUrl] : const [],
        isAvailable: _isAvailable,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      widget.cubit.addProduct(newProduct);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added "${newProduct.title}" to catalog'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.lg,
      ),
      child: Container(
        width: DashboardConstants.productFormDialogWidth,
        constraints: const BoxConstraints(maxHeight: 740),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Modal Header
            _buildHeader(),

            // Modal Body Form
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.xl),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Title
                      _buildTitleField(),
                      const SizedBox(height: AppSizes.md),

                      // Category & Price Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ProductCategorySelector(
                              selectedCategory: _selectedCategory,
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedCategory = val);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: AppSizes.md),
                          Expanded(child: _buildPriceField()),
                        ],
                      ),
                      const SizedBox(height: AppSizes.md),

                      // Stock Quantity Field
                      _buildStockField(),
                      const SizedBox(height: AppSizes.md),

                      // Image URL with Live Thumbnail Preview
                      ProductImagePreviewField(controller: _imageUrlController),
                      const SizedBox(height: AppSizes.md),

                      // Description Field
                      _buildDescriptionField(),
                      const SizedBox(height: AppSizes.md),

                      // Availability Switch Tile
                      ProductAvailabilityTile(
                        isAvailable: _isAvailable,
                        onChanged: (val) => setState(() => _isAvailable = val),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Modal Footer Actions
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.xl,
        vertical: AppSizes.lg,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1.0),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Icon(
              _isEditing ? IconsaxPlusLinear.edit_2 : IconsaxPlusLinear.box_add,
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
                  _isEditing ? 'Edit Product' : 'Add New Product',
                  style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  _isEditing
                      ? 'Update catalog details, pricing, and stock status'
                      : 'Create a new inventory item in your store catalog',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              IconsaxPlusLinear.close_circle,
              color: AppColors.textSecondary,
            ),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Title *',
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSizes.xs + 2),
        AppTextField(
          controller: _titleController,
          hintText: 'e.g. Wireless Noise Canceling Headphones',
          prefixIcon: IconsaxPlusLinear.tag,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a product title';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPriceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price (₹ INR) *',
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSizes.xs + 2),
        AppTextField(
          controller: _priceController,
          hintText: 'e.g. 1999',
          prefixIcon: IconsaxPlusLinear.money_recive,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter price';
            }
            final numVal = double.tryParse(value.trim());
            if (numVal == null || numVal <= 0) {
              return 'Enter valid price > 0';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildStockField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stock Level',
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSizes.xs + 2),
        AppTextField(
          controller: _stockController,
          hintText: 'e.g. 50 (units in inventory)',
          prefixIcon: IconsaxPlusLinear.box,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter stock quantity';
            }
            final intVal = int.tryParse(value.trim());
            if (intVal == null || intVal < 0) {
              return 'Enter integer >= 0';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSizes.xs + 2),
        AppTextField(
          controller: _descriptionController,
          hintText: 'Brief summary of item highlights, materials, features...',
          maxLines: 3,
          prefixIcon: IconsaxPlusLinear.document_text,
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.xl,
        vertical: AppSizes.md,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider, width: 1.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppButton.compact(
            label: 'Cancel',
            isOutlined: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: AppSizes.md),
          AppButton.compact(
            label: _isEditing ? 'Save Changes' : 'Add Product',
            icon: _isEditing
                ? IconsaxPlusLinear.tick_circle
                : IconsaxPlusLinear.add,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
