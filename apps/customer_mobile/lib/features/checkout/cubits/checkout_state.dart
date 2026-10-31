import 'package:shopease_core/shopease_core.dart';

// State representing the product checkout
class CheckoutState extends Equatable {
  const CheckoutState({
    required this.address,
    this.paymentMethod = PaymentMethodType.upi,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.placedOrder,
    this.errorMessage,
  });

  final CustomerAddressModel address;
  final PaymentMethodType paymentMethod;
  final bool isSubmitting;
  final bool isSuccess;
  final OrderModel? placedOrder;
  final String? errorMessage;

  bool get isAddressValid =>
      address.street.trim().isNotEmpty &&
      address.city.trim().isNotEmpty &&
      address.postalCode.trim().isNotEmpty;

  CheckoutState copyWith({
    CustomerAddressModel? address,
    PaymentMethodType? paymentMethod,
    bool? isSubmitting,
    bool? isSuccess,
    OrderModel? placedOrder,
    String? errorMessage,
  }) {
    return CheckoutState(
      address: address ?? this.address,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      placedOrder: placedOrder ?? this.placedOrder,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    address,
    paymentMethod,
    isSubmitting,
    isSuccess,
    placedOrder,
    errorMessage,
  ];
}
