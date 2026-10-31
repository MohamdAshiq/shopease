import 'package:flutter_bloc/flutter_bloc.dart';
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
              mockCustomer.address ??
              const CustomerAddressModel(
                street: '742 Evergreen Terrace',
                city: 'Springfield',
                state: 'OR',
                postalCode: '97477',
                country: 'India',
                recipientName: 'Alex Morgan',
                phone: '+91 98765 43210',
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
      await Future<void>.delayed(const Duration(milliseconds: 700));

      final order = await orderCubit.placeOrder(
        address: state.address,
        cartItems: cartState.items,
        subtotal: cartState.subtotal,
        deliveryFee: cartState.deliveryFee,
        total: cartState.total,
        paymentMethod: state.paymentMethod,
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
