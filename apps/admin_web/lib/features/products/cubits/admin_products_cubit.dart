import 'dart:async';

import 'package:shopease_core/shopease_core.dart';

import 'admin_products_state.dart';

class AdminProductsCubit extends Cubit<AdminProductsState> {
  AdminProductsCubit({ProductRepository? productRepository})
    : _productRepository = productRepository ?? FirestoreProductRepository(),
      super(const AdminProductsState());

  final ProductRepository _productRepository;
  StreamSubscription<List<ProductModel>>? _productsSubscription;

  Future<void> loadProducts() async {
    emit(state.copyWith(status: AdminProductsStatus.loading));
    _productsSubscription?.cancel();

    _productsSubscription = _productRepository.streamProducts().listen(
      (products) {
        emit(
          state.copyWith(
            status: AdminProductsStatus.loaded,
            products: products,
          ),
        );
      },
      onError: (e) {
        emit(
          state.copyWith(
            status: AdminProductsStatus.error,
            errorMessage: e.toString(),
          ),
        );
      },
    );
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

  Future<void> addProduct(ProductModel product) async {
    try {
      await _productRepository.addProduct(product);
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      await _productRepository.updateProduct(product);
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _productRepository.deleteProduct(id);
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> toggleAvailability(String id) async {
    try {
      final product = state.products.firstWhere((p) => p.id == id);
      await updateProduct(product.copyWith(isAvailable: !product.isAvailable));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _productsSubscription?.cancel();
    return super.close();
  }
}
