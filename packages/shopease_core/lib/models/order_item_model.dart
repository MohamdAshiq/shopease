import 'package:equatable/equatable.dart';

// Each Order Item Model
class OrderItemModel extends Equatable {
  const OrderItemModel({
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    this.imageUrl = '',
  });

  final String productId;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;

  double get totalPrice => price * quantity;

  OrderItemModel copyWith({
    String? productId,
    String? title,
    double? price,
    int? quantity,
    String? imageUrl,
  }) {
    return OrderItemModel(
      productId: productId ?? this.productId,
      title: title ?? this.title,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      productId: map['productId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      imageUrl: map['imageUrl'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [productId, title, price, quantity, imageUrl];
}
