import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease_core/shopease_core.dart';

import 'wishlist_state.dart';

// Cubit managing wishlist
class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit({List<ProductModel>? initialItems})
    : super(
        WishlistState(
          items:
              initialItems ??
              (mockProducts.length >= 3
                  ? [mockProducts[0], mockProducts[2]]
                  : mockProducts.take(2).toList()),
        ),
      );

  // Sets the active filter for the wishlist
  void setFilter(WishlistFilter filter) {
    if (state.selectedFilter == filter) return;
    emit(state.copyWith(selectedFilter: filter));
  }

  // Toggles wishlist value
  bool toggleWishlist(ProductModel product) {
    if (state.isFavorite(product.id)) {
      removeFromWishlist(product.id);
      return false;
    } else {
      addToWishlist(product);
      return true;
    }
  }

  // Adds a product to the wishlist
  void addToWishlist(ProductModel product) {
    if (state.isFavorite(product.id)) return;
    final updatedList = List<ProductModel>.from(state.items)
      ..insert(0, product);
    emit(state.copyWith(items: updatedList));
  }

  // Removes a product from the wishlist
  void removeFromWishlist(String productId) {
    if (!state.isFavorite(productId)) return;
    final updatedList = state.items
        .where((product) => product.id != productId)
        .toList();
    emit(state.copyWith(items: updatedList));
  }

  // Clears all items from the wishlist
  void clearWishlist() {
    if (state.isEmpty) return;
    emit(const WishlistState(items: []));
  }
}
