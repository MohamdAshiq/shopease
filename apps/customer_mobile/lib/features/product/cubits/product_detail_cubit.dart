import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease_core/shopease_core.dart';

// State model for the Product Detail screen
class ProductDetailState extends Equatable {
  const ProductDetailState({
    this.quantity = 1,
    this.selectedImageIndex = 0,
    this.selectedSize = '',
  });

  final int quantity;
  final int selectedImageIndex;
  final String selectedSize;

  ProductDetailState copyWith({
    int? quantity,
    int? selectedImageIndex,
    String? selectedSize,
  }) {
    return ProductDetailState(
      quantity: quantity ?? this.quantity,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
      selectedSize: selectedSize ?? this.selectedSize,
    );
  }

  @override
  List<Object?> get props => [quantity, selectedImageIndex, selectedSize];
}

// Cubit managing state for Product Detail screen
class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit({String initialSize = ''})
    : super(ProductDetailState(selectedSize: initialSize));

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

  void selectSize(String size) {
    emit(state.copyWith(selectedSize: size));
  }
}
