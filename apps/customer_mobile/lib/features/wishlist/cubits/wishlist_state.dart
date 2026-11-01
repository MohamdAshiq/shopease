import 'package:shopease_core/shopease_core.dart';

// Filter types for the wishlist items
enum WishlistFilter { all, inStock, discount }

// Wishlist State
class WishlistState extends Equatable {
  const WishlistState({
    this.items = const [],
    this.selectedFilter = WishlistFilter.all,
  });

  final List<ProductModel> items;
  final WishlistFilter selectedFilter;

  // Set of product IDs
  Set<String> get itemIds => items.map((product) => product.id).toSet();

  // Number of items in wishlist
  int get itemCount => items.length;

  // Wishlist empty check
  bool get isEmpty => items.isEmpty;

  // Wishlist not empty check
  bool get isNotEmpty => items.isNotEmpty;

  // Count of currently in-stock items
  int get inStockCount => items.where((p) => p.isInStock).length;

  // Count of items that currently have a discount
  int get discountCount => items.where((p) => p.discountPercentage > 0).length;

  // Filtered items based on selectedFilter
  List<ProductModel> get filteredItems {
    switch (selectedFilter) {
      case WishlistFilter.all:
        return items;
      case WishlistFilter.inStock:
        return items.where((p) => p.isInStock).toList();
      case WishlistFilter.discount:
        return items.where((p) => p.discountPercentage > 0).toList();
    }
  }

  // Check if a specific product is in the wishlist
  bool isFavorite(String productId) => itemIds.contains(productId);

  WishlistState copyWith({
    List<ProductModel>? items,
    WishlistFilter? selectedFilter,
  }) {
    return WishlistState(
      items: items ?? this.items,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  List<Object?> get props => [items, selectedFilter];
}
