import 'package:shopease_core/shopease_core.dart';

// State representing the cart
class CartState extends Equatable {
  const CartState({this.items = const []});

  final List<CartItemModel> items;

  // Free delivery on orders over ₹999
  static const double freeDeliveryThreshold = 999.0;
  static const double standardDeliveryFee = 49.0;

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee =>
      isEmpty || subtotal >= freeDeliveryThreshold ? 0.0 : standardDeliveryFee;

  bool get isFreeDelivery => deliveryFee == 0.0 && isNotEmpty;

  double get total => subtotal + deliveryFee;

  // Total original price
  double get totalOriginalPrice => items.fold(
    0.0,
    (sum, item) => sum + (item.product.originalPrice * item.quantity),
  );

  // Total savings customer receives on this order
  double get totalSavings => totalOriginalPrice - subtotal;

  bool isProductInCart(String productId, [String selectedSize = '']) =>
      items.any(
        (item) =>
            item.product.id == productId && item.selectedSize == selectedSize,
      );

  bool isAnySizeInCart(String productId) =>
      items.any((item) => item.product.id == productId);

  CartState copyWith({List<CartItemModel>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}
