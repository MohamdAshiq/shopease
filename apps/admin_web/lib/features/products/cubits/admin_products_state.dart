import 'package:shopease_core/shopease_core.dart';

import '../../dashboard/constants/dashboard_constants.dart';

enum AdminProductsStatus { initial, loading, loaded, error }

enum StockFilter { all, inStock, lowStock, outOfStock }

enum ProductSortBy { newest, priceLowToHigh, priceHighToLow, stock }

class AdminProductsState extends Equatable {
  const AdminProductsState({
    this.status = AdminProductsStatus.initial,
    this.products = const [],
    this.searchQuery = '',
    this.selectedCategory = 'All',
    this.stockFilter = StockFilter.all,
    this.sortBy = ProductSortBy.newest,
    this.currentPage = 1,
    this.itemsPerPage = DashboardConstants.defaultProductsPerPage,
    this.errorMessage,
  });

  final AdminProductsStatus status;
  final List<ProductModel> products;
  final String searchQuery;
  final String selectedCategory;
  final StockFilter stockFilter;
  final ProductSortBy sortBy;
  final int currentPage;
  final int itemsPerPage;
  final String? errorMessage;

  // Filtered and sorted products
  List<ProductModel> get filteredProducts {
    var result = List<ProductModel>.from(products);

    // Search query filter
    if (searchQuery.trim().isNotEmpty) {
      final query = searchQuery.toLowerCase().trim();
      result = result.where((p) {
        return p.title.toLowerCase().contains(query) ||
            p.id.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query);
      }).toList();
    }

    // Category filter
    if (selectedCategory != 'All') {
      result = result.where((p) => p.category == selectedCategory).toList();
    }

    // Stock filter
    switch (stockFilter) {
      case StockFilter.all:
        break;
      case StockFilter.inStock:
        result = result
            .where(
              (p) =>
                  p.stock >= DashboardConstants.lowStockThreshold &&
                  p.isAvailable,
            )
            .toList();
        break;
      case StockFilter.lowStock:
        result = result
            .where(
              (p) =>
                  p.stock > 0 &&
                  p.stock < DashboardConstants.lowStockThreshold &&
                  p.isAvailable,
            )
            .toList();
        break;
      case StockFilter.outOfStock:
        result = result.where((p) => p.stock == 0 || !p.isAvailable).toList();
        break;
    }

    // Sort order
    switch (sortBy) {
      case ProductSortBy.newest:
        result.sort((a, b) {
          final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bDate.compareTo(aDate);
        });
        break;
      case ProductSortBy.priceLowToHigh:
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSortBy.priceHighToLow:
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSortBy.stock:
        result.sort((a, b) => a.stock.compareTo(b.stock));
        break;
    }

    return result;
  }

  // Current page items for pagination
  List<ProductModel> get paginatedProducts {
    final filtered = filteredProducts;
    final startIndex = (currentPage - 1) * itemsPerPage;
    if (startIndex >= filtered.length) return [];
    final endIndex = (startIndex + itemsPerPage).clamp(0, filtered.length);
    return filtered.sublist(startIndex, endIndex);
  }

  int get totalPages {
    final count = filteredProducts.length;
    if (count == 0) return 1;
    return (count / itemsPerPage).ceil();
  }

  // Catalog metric counts
  int get inStockCount => products
      .where(
        (p) => p.stock >= DashboardConstants.lowStockThreshold && p.isAvailable,
      )
      .length;

  int get lowStockCount => products
      .where(
        (p) =>
            p.stock > 0 &&
            p.stock < DashboardConstants.lowStockThreshold &&
            p.isAvailable,
      )
      .length;

  int get outOfStockCount =>
      products.where((p) => p.stock == 0 || !p.isAvailable).length;

  AdminProductsState copyWith({
    AdminProductsStatus? status,
    List<ProductModel>? products,
    String? searchQuery,
    String? selectedCategory,
    StockFilter? stockFilter,
    ProductSortBy? sortBy,
    int? currentPage,
    int? itemsPerPage,
    String? errorMessage,
  }) {
    return AdminProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      stockFilter: stockFilter ?? this.stockFilter,
      sortBy: sortBy ?? this.sortBy,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    searchQuery,
    selectedCategory,
    stockFilter,
    sortBy,
    currentPage,
    itemsPerPage,
    errorMessage,
  ];
}
