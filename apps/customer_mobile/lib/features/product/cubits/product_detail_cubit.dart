import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease_core/shopease_core.dart';

// State model for the Product Detail screen
class ProductDetailState extends Equatable {
  const ProductDetailState({
    this.quantity = 1,
    this.selectedImageIndex = 0,
    this.isFavorite = false,
    this.selectedSize = '',
  });

  final int quantity;
  final int selectedImageIndex;
  final bool isFavorite;
  final String selectedSize;

  ProductDetailState copyWith({
    int? quantity,
    int? selectedImageIndex,
    bool? isFavorite,
    String? selectedSize,
  }) {
    return ProductDetailState(
      quantity: quantity ?? this.quantity,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
      isFavorite: isFavorite ?? this.isFavorite,
      selectedSize: selectedSize ?? this.selectedSize,
    );
  }

  @override
  List<Object?> get props => [
    quantity,
    selectedImageIndex,
    isFavorite,
    selectedSize,
  ];
}

// Cubit managing state for Product Detail screen
class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit({bool isInitialFavorite = false, String initialSize = ''})
    : super(
        ProductDetailState(
          isFavorite: isInitialFavorite,
          selectedSize: initialSize,
        ),
      );

  void incrementQuantity(int maxStock) {
    if (state.quantity < maxStock) {
      emit(state.copyWith(quantity: state.quantity + 1));
    }
  }

  void decrementQuantity() {
    if (state.quantity > 1) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }

  void selectImage(int index) {
    emit(state.copyWith(selectedImageIndex: index));
  }

  void toggleFavorite() {
    emit(state.copyWith(isFavorite: !state.isFavorite));
  }

  void selectSize(String size) {
    emit(state.copyWith(selectedSize: size));
  }
}
