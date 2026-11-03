import 'dart:async';

import 'package:shopease_core/shopease_core.dart';

import 'search_state.dart';

// Cubit handling search and recent search history
class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    SearchHistoryService? historyService,
    ProductRepository? productRepository,
    List<ProductModel>? initialProducts,
    String initialQuery = '',
  }) : _historyService = historyService ?? SearchHistoryService(),
       _productRepository = productRepository ?? FirestoreProductRepository(),
       super(
         SearchState(
           allProducts: initialProducts ?? const [],
           searchResults: const [],
           searchQuery: initialQuery,
         ),
       ) {
    _loadRecentSearches();
    if (initialProducts != null && initialProducts.isNotEmpty) {
      if (initialQuery.isNotEmpty) {
        updateQuery(initialQuery);
      }
    } else {
      _subscribeToProducts();
    }
  }

  final SearchHistoryService _historyService;
  final ProductRepository _productRepository;
  StreamSubscription<List<ProductModel>>? _productsSubscription;

  void _subscribeToProducts() {
    _productsSubscription = _productRepository.streamProducts().listen((
      products,
    ) {
      if (!isClosed) {
        emit(state.copyWith(allProducts: products));
        if (state.searchQuery.isNotEmpty) {
          updateQuery(state.searchQuery);
        }
      }
    });
  }

  // Load recent searches
  Future<void> _loadRecentSearches() async {
    final history = await _historyService.getRecentSearches();
    if (!isClosed) {
      emit(state.copyWith(recentSearches: history, isLoadingHistory: false));
    }
  }

  // Search function
  void updateQuery(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      emit(state.copyWith(searchQuery: '', searchResults: const []));
      return;
    }

    final queryLower = trimmed.toLowerCase();
    final results = state.allProducts.where((product) {
      final titleMatch = product.title.toLowerCase().contains(queryLower);
      final categoryMatch = product.category.toLowerCase().contains(queryLower);
      final descriptionMatch = product.description.toLowerCase().contains(
        queryLower,
      );
      return titleMatch || categoryMatch || descriptionMatch;
    }).toList();

    emit(state.copyWith(searchQuery: query, searchResults: results));
  }

  // Submit search function
  Future<void> submitSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final updatedRecent = await _historyService.addSearch(trimmed);
    updateQuery(trimmed);

    if (!isClosed) {
      emit(state.copyWith(recentSearches: updatedRecent));
    }
  }

  // Remove recent search function
  Future<void> removeRecentSearch(String item) async {
    final updatedRecent = await _historyService.removeSearch(item);
    if (!isClosed) {
      emit(state.copyWith(recentSearches: updatedRecent));
    }
  }

  // Clear search function
  Future<void> clearRecentSearches() async {
    await _historyService.clearHistory();
    if (!isClosed) {
      emit(state.copyWith(recentSearches: const []));
    }
  }

  @override
  Future<void> close() {
    _productsSubscription?.cancel();
    return super.close();
  }
}
