import 'package:shopease_core/shopease_core.dart';

// State model for the Product Detail screen
class ProductDetailState extends Equatable {
  const ProductDetailState({this.quantity = 1, this.selectedSize = ''});

  final int quantity;
  final String selectedSize;

  ProductDetailState copyWith({int? quantity, String? selectedSize}) {
    return ProductDetailState(
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
    );
  }

  @override
  List<Object?> get props => [quantity, selectedSize];
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

  void selectSize(String size) {
    emit(state.copyWith(selectedSize: size));
  }
}
