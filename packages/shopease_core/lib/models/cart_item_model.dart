import 'package:equatable/equatable.dart';

import 'order_item_model.dart';
import 'product_model.dart';

// Each Cart Item
class CartItemModel extends Equatable {
  const CartItemModel({
    required this.product,
    this.selectedSize = '',
    this.quantity = 1,
  });

  final ProductModel product;
  final String selectedSize;
  final int quantity;

  // Id for each cart item
  String get id =>
      selectedSize.isEmpty ? product.id : '${product.id}_$selectedSize';

  double get totalPrice => product.price * quantity;

  CartItemModel copyWith({
    ProductModel? product,
    String? selectedSize,
    int? quantity,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      selectedSize: selectedSize ?? this.selectedSize,
      quantity: quantity ?? this.quantity,
    );
  }

  // Convert to OrderItemModel for checkout
  OrderItemModel toOrderItem() {
    final titleWithSize = selectedSize.isNotEmpty
        ? '${product.title} ($selectedSize)'
        : product.title;

    return OrderItemModel(
      productId: product.id,
      title: titleWithSize,
      price: product.price,
      quantity: quantity,
      imageUrl: product.primaryImageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'selectedSize': selectedSize,
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      product: ProductModel.fromMap(map['product'] as Map<String, dynamic>),
      selectedSize: map['selectedSize'] as String? ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  @override
  List<Object?> get props => [product, selectedSize, quantity];
}
