import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import '../cubits/cart_cubit.dart';

// SnackBar Helper when an item is added to cart
abstract final class CartActionHelper {
  static AddToCartResult addToCart(
    BuildContext context, {
    required ProductModel product,
    String selectedSize = '',
    int quantity = 1,
  }) {
    final result = context.read<CartCubit>().addToCart(
      product,
      selectedSize: selectedSize,
      quantity: quantity,
    );

    // Max Stock Reached
    if (result == AddToCartResult.maxStockReached) {
      HapticFeedback.selectionClick();
      AppSnackBar.showError(
        context,
        'Maximum available stock (${product.stock}) already in cart',
      );
    }
    // Out of Stock
    else if (result == AddToCartResult.outOfStock) {
      HapticFeedback.selectionClick();
      AppSnackBar.showError(context, 'This product is currently out of stock');
    }
    // Added to Cart
    else {
      HapticFeedback.lightImpact();
      AppSnackBar.show(
        context,
        message: selectedSize.isNotEmpty
            ? 'Added "${product.title}" (Size $selectedSize) to cart'
            : 'Added "${product.title}" to cart',
      );
    }
    return result;
  }
}
