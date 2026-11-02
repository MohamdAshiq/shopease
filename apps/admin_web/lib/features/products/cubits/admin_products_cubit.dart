import 'package:shopease_core/shopease_core.dart';

import 'admin_products_state.dart';

class AdminProductsCubit extends Cubit<AdminProductsState> {
  AdminProductsCubit() : super(const AdminProductsState());

  void loadProducts() {
    emit(state.copyWith(status: AdminProductsStatus.loading));
    try {
      emit(
        state.copyWith(
          status: AdminProductsStatus.loaded,
          products: List<ProductModel>.from(mockProducts),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminProductsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query, currentPage: 1));
  }

  void filterByCategory(String category) {
    emit(state.copyWith(selectedCategory: category, currentPage: 1));
  }

  void filterByStock(StockFilter filter) {
    emit(state.copyWith(stockFilter: filter, currentPage: 1));
  }

  void changeSort(ProductSortBy sortBy) {
    emit(state.copyWith(sortBy: sortBy, currentPage: 1));
  }

  void changePage(int page) {
    if (page < 1 || page > state.totalPages) return;
    emit(state.copyWith(currentPage: page));
  }

  void addProduct(ProductModel product) {
    final updatedList = [product, ...state.products];
    emit(state.copyWith(products: updatedList, currentPage: 1));
  }

  void updateProduct(ProductModel product) {
    final updatedList = state.products.map((p) {
      return p.id == product.id ? product : p;
    }).toList();
    emit(state.copyWith(products: updatedList));
  }

  void deleteProduct(String id) {
    final updatedList = state.products.where((p) => p.id != id).toList();
    final newTotalPages = (updatedList.length / state.itemsPerPage)
        .ceil()
        .clamp(1, 999);
    final validPage = state.currentPage > newTotalPages
        ? newTotalPages
        : state.currentPage;
    emit(state.copyWith(products: updatedList, currentPage: validPage));
  }

  void toggleAvailability(String id) {
    final updatedList = state.products.map((p) {
      if (p.id == id) {
        return p.copyWith(isAvailable: !p.isAvailable);
      }
      return p;
    }).toList();
    emit(state.copyWith(products: updatedList));
  }
}
