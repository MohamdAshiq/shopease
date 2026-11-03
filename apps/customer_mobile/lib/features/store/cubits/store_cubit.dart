import 'dart:async';

import 'package:shopease_core/shopease_core.dart';

// Sort options for the product catalog
enum StoreSortOption {
  featured('Featured'),
  priceLowToHigh('Price: Low to High'),
  priceHighToLow('Price: High to Low'),
  nameAZ('Name: A to Z');

  const StoreSortOption(this.label);
  final String label;
}

// State for the Store screen
class StoreState extends Equatable {
  const StoreState({
    required this.allProducts,
    required this.filteredProducts,
    required this.availableCategories,
    this.searchQuery = '',
    this.selectedCategory = 'All',
    this.selectedSort = StoreSortOption.featured,
    this.isLoading = false,
    this.errorMessage,
  });

  final List<ProductModel> allProducts;
  final List<ProductModel> filteredProducts;
  final List<String> availableCategories;
  final String searchQuery;
  final String selectedCategory;
  final StoreSortOption selectedSort;
  final bool isLoading;
  final String? errorMessage;

  StoreState copyWith({
    List<ProductModel>? allProducts,
    List<ProductModel>? filteredProducts,
    List<String>? availableCategories,
    String? searchQuery,
    String? selectedCategory,
    StoreSortOption? selectedSort,
    bool? isLoading,
    String? errorMessage,
  }) {
    return StoreState(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      availableCategories: availableCategories ?? this.availableCategories,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSort: selectedSort ?? this.selectedSort,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    allProducts,
    filteredProducts,
    availableCategories,
    searchQuery,
    selectedCategory,
    selectedSort,
    isLoading,
    errorMessage,
  ];
}

// Cubit managing filtering, searching and sorting
class StoreCubit extends Cubit<StoreState> {
  StoreCubit({
    ProductRepository? productRepository,
    List<ProductModel>? initialProducts,
    String initialCategory = 'All',
  }) : _productRepository = productRepository ?? FirestoreProductRepository(),
       super(
         _computeInitialState(
           initialProducts ?? const [],
           initialCategory: initialCategory,
           isLoading: initialProducts == null,
         ),
       ) {
    if (initialProducts == null) {
      loadProducts();
    }
  }

  final ProductRepository _productRepository;
  StreamSubscription<List<ProductModel>>? _productsSubscription;

  void loadProducts() {
    emit(state.copyWith(isLoading: true));
    _productsSubscription?.cancel();
    _productsSubscription = _productRepository.streamProducts().listen(
      (products) {
        final allCategories = AppCategories.categoryNamesFromProducts(products);

        emit(
          _filter(
            state.copyWith(
              allProducts: products,
              availableCategories: allCategories,
              isLoading: false,
              errorMessage: null,
            ),
          ),
        );
      },
      onError: (err) {
        emit(state.copyWith(isLoading: false, errorMessage: err.toString()));
      },
    );
  }

  static StoreState _computeInitialState(
    List<ProductModel> products, {
    String initialCategory = 'All',
    bool isLoading = false,
  }) {
    final categories = AppCategories.categoryNamesFromProducts(products);

    final effectiveCategory = categories.firstWhere(
      (c) => c.toLowerCase() == initialCategory.toLowerCase(),
      orElse: () => 'All',
    );

    final base = StoreState(
      allProducts: products,
      filteredProducts: products,
      availableCategories: categories,
      searchQuery: '',
      selectedCategory: effectiveCategory,
      selectedSort: StoreSortOption.featured,
      isLoading: isLoading,
    );

    return _filter(base);
  }

  void updateSearchQuery(String query) {
    emit(_filter(state.copyWith(searchQuery: query)));
  }

  void selectCategory(String category) {
    if (state.selectedCategory == category) return;
    emit(_filter(state.copyWith(selectedCategory: category)));
  }

  void selectSort(StoreSortOption sort) {
    if (state.selectedSort == sort) return;
    emit(_filter(state.copyWith(selectedSort: sort)));
  }

  void resetFilters() {
    emit(
      _filter(
        state.copyWith(
          searchQuery: '',
          selectedCategory: 'All',
          selectedSort: StoreSortOption.featured,
        ),
      ),
    );
  }

  static StoreState _filter(StoreState current) {
    final trimmedQuery = current.searchQuery.trim().toLowerCase();

    final matching = current.allProducts.where((product) {
      if (!product.isAvailable) return false;

      final matchesCategory =
          current.selectedCategory == 'All' ||
          product.category.toLowerCase() ==
              current.selectedCategory.toLowerCase();

      final matchesQuery =
          trimmedQuery.isEmpty ||
          product.title.toLowerCase().contains(trimmedQuery) ||
          product.description.toLowerCase().contains(trimmedQuery) ||
          product.category.toLowerCase().contains(trimmedQuery);

      return matchesCategory && matchesQuery;
    }).toList();

    matching.sort((a, b) {
      switch (current.selectedSort) {
        case StoreSortOption.priceLowToHigh:
          return a.price.compareTo(b.price);
        case StoreSortOption.priceHighToLow:
          return b.price.compareTo(a.price);
        case StoreSortOption.nameAZ:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case StoreSortOption.featured:
          return 0;
      }
    });

    return current.copyWith(filteredProducts: matching);
  }

  @override
  Future<void> close() {
    _productsSubscription?.cancel();
    return super.close();
  }
}
