import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease_core/shopease_core.dart';

import 'cart_state.dart';

// Result of an addToCart operation
enum AddToCartResult { success, maxStockReached, outOfStock }

// Cubit managing shopping cart
class CartCubit extends Cubit<CartState> {
  CartCubit({
    List<CartItemModel>? initialItems,
    CartStorageService? storageService,
  }) : _storageService = storageService ?? CartStorageService(),
       super(CartState(items: initialItems ?? const [])) {
    if (initialItems == null) {
      _loadSavedCart();
    }
  }

  final CartStorageService _storageService;

  Future<void> _loadSavedCart() async {
    final saved = await _storageService.loadCart();
    if (saved.isNotEmpty) {
      emit(state.copyWith(items: saved));
    }
  }

  void _saveCart() {
    _storageService.saveCart(state.items);
  }

  // Add product to cart or increment quantity if already present
  AddToCartResult addToCart(
    ProductModel product, {
    String selectedSize = '',
    int quantity = 1,
  }) {
    if (!product.isInStock) {
      return AddToCartResult.outOfStock;
    }

    final existingIndex = state.items.indexWhere(
      (item) =>
          item.product.id == product.id && item.selectedSize == selectedSize,
    );

    final updatedItems = List<CartItemModel>.from(state.items);

    if (existingIndex != -1) {
      final existing = updatedItems[existingIndex];
      if (existing.quantity >= product.stock) {
        return AddToCartResult.maxStockReached;
      }
      final newQuantity = (existing.quantity + quantity).clamp(
        1,
        product.stock,
      );
      updatedItems[existingIndex] = existing.copyWith(quantity: newQuantity);
    } else {
      updatedItems.add(
        CartItemModel(
          product: product,
          selectedSize: selectedSize,
          quantity: quantity.clamp(1, product.stock),
        ),
      );
    }

    emit(state.copyWith(items: updatedItems));
    _saveCart();
    return AddToCartResult.success;
  }

  // Undo Option
  void restoreItem(int index, CartItemModel item) {
    final updatedItems = List<CartItemModel>.from(state.items);
    final clampedIndex = index.clamp(0, updatedItems.length);
    updatedItems.insert(clampedIndex, item);
    emit(state.copyWith(items: updatedItems));
    _saveCart();
  }

  // Update item quantity
  void updateQuantity(String productId, String selectedSize, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId, selectedSize);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.product.id == productId && item.selectedSize == selectedSize) {
        final clampedQty = quantity.clamp(1, item.product.stock);
        return item.copyWith(quantity: clampedQty);
      }
      return item;
    }).toList();

    emit(state.copyWith(items: updatedItems));
    _saveCart();
  }

  // Increment item quantity
  void incrementQuantity(String productId, String selectedSize) {
    final item = state.items.firstWhere(
      (i) => i.product.id == productId && i.selectedSize == selectedSize,
      orElse: () => throw Exception('Item not found in cart'),
    );
    updateQuantity(productId, selectedSize, item.quantity + 1);
  }

  // Decrement item quantity
  void decrementQuantity(String productId, String selectedSize) {
    final item = state.items.firstWhere(
      (i) => i.product.id == productId && i.selectedSize == selectedSize,
      orElse: () => throw Exception('Item not found in cart'),
    );
    updateQuantity(productId, selectedSize, item.quantity - 1);
  }

  // Remove a specific line item
  void removeFromCart(String productId, String selectedSize) {
    final updatedItems = state.items.where((item) {
      return !(item.product.id == productId &&
          item.selectedSize == selectedSize);
    }).toList();

    emit(state.copyWith(items: updatedItems));
    _saveCart();
  }

  // Clear all items from cart
  void clearCart() {
    emit(const CartState(items: []));
    _saveCart();
  }
}
