import 'package:shopease_core/shopease_core.dart';

// State for the Search screen
class SearchState extends Equatable {
  const SearchState({
    required this.allProducts,
    required this.searchResults,
    this.searchQuery = '',
    this.recentSearches = const [],
    this.isLoadingHistory = true,
  });

  final List<ProductModel> allProducts;
  final List<ProductModel> searchResults;
  final String searchQuery;
  final List<String> recentSearches;
  final bool isLoadingHistory;

  bool get isIdle => searchQuery.trim().isEmpty;
  bool get hasResults => searchResults.isNotEmpty;

  SearchState copyWith({
    List<ProductModel>? allProducts,
    List<ProductModel>? searchResults,
    String? searchQuery,
    List<String>? recentSearches,
    bool? isLoadingHistory,
  }) {
    return SearchState(
      allProducts: allProducts ?? this.allProducts,
      searchResults: searchResults ?? this.searchResults,
      searchQuery: searchQuery ?? this.searchQuery,
      recentSearches: recentSearches ?? this.recentSearches,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
    );
  }

  @override
  List<Object?> get props => [
    allProducts,
    searchResults,
    searchQuery,
    recentSearches,
    isLoadingHistory,
  ];
}
