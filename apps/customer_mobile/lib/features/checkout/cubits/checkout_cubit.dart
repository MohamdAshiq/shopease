import 'package:shopease_core/shopease_core.dart';

import '../../cart/cubits/cart_cubit.dart';
import '../../orders/cubits/order_cubit.dart';
import 'checkout_state.dart';

// Cubit handling product checkouts
class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit({CustomerAddressModel? initialAddress})
    : super(
        CheckoutState(
          address:
              initialAddress ??
              const CustomerAddressModel(
                street: '',
                city: '',
                state: '',
                postalCode: '',
                country: '',
              ),
        ),
      );

  void updateAddress(CustomerAddressModel newAddress) {
    emit(state.copyWith(address: newAddress, errorMessage: null));
  }

  void selectPaymentMethod(PaymentMethodType method) {
    emit(state.copyWith(paymentMethod: method, errorMessage: null));
  }

  Future<OrderModel?> placeOrder({
    required OrderCubit orderCubit,
    required CartCubit cartCubit,
    UserModel? customer,
  }) async {
    final cartState = cartCubit.state;
    if (cartState.isEmpty) {
      emit(state.copyWith(errorMessage: 'Your cart is empty.'));
      return null;
    }

    if (!state.isAddressValid) {
      emit(
        state.copyWith(
          errorMessage: 'Please provide a valid delivery address.',
        ),
      );
      return null;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      final order = await orderCubit.placeOrder(
        address: state.address,
        cartItems: cartState.items,
        subtotal: cartState.subtotal,
        deliveryFee: cartState.deliveryFee,
        total: cartState.total,
        paymentMethod: state.paymentMethod,
        customer: customer,
      );

      // Clear shopping cart on successful checkout
      cartCubit.clearCart();

      if (!isClosed) {
        emit(
          state.copyWith(
            isSubmitting: false,
            isSuccess: true,
            placedOrder: order,
          ),
        );
      }

      return order;
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isSubmitting: false,
            errorMessage: 'Failed to place order: $e',
          ),
        );
      }
      return null;
    }
  }
}
