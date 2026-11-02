import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

// Supported Payment Methods
enum PaymentMethodType {
  cod,
  upi,
  card,
  netbanking;

  String get title {
    switch (this) {
      case PaymentMethodType.cod:
        return 'Cash on Delivery';
      case PaymentMethodType.upi:
        return 'Google Pay / PhonePe / UPI';
      case PaymentMethodType.card:
        return 'Credit / Debit Card';
      case PaymentMethodType.netbanking:
        return 'Net Banking';
    }
  }

  String get shortLabel {
    switch (this) {
      case PaymentMethodType.cod:
        return 'Cash on Delivery';
      case PaymentMethodType.upi:
        return 'UPI';
      case PaymentMethodType.card:
        return 'Card';
      case PaymentMethodType.netbanking:
        return 'Net Banking';
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentMethodType.cod:
        return IconsaxPlusBold.money_tick;
      case PaymentMethodType.upi:
        return IconsaxPlusBold.scan_barcode;
      case PaymentMethodType.card:
        return IconsaxPlusBold.card_pos;
      case PaymentMethodType.netbanking:
        return IconsaxPlusBold.bank;
    }
  }

  IconData get linearIcon {
    switch (this) {
      case PaymentMethodType.cod:
        return IconsaxPlusLinear.money;
      case PaymentMethodType.upi:
        return IconsaxPlusLinear.mobile;
      case PaymentMethodType.card:
        return IconsaxPlusLinear.card;
      case PaymentMethodType.netbanking:
        return IconsaxPlusLinear.bank;
    }
  }

  static PaymentMethodType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'upi':
        return PaymentMethodType.upi;
      case 'card':
        return PaymentMethodType.card;
      case 'netbanking':
        return PaymentMethodType.netbanking;
      case 'cod':
      default:
        return PaymentMethodType.cod;
    }
  }
}

class PaymentMethodModel extends Equatable {
  const PaymentMethodModel({
    required this.type,
    required this.title,
    required this.icon,
  });

  final PaymentMethodType type;
  final String title;
  final IconData icon;

  static List<PaymentMethodModel> get supportedMethods =>
      PaymentMethodType.values.map((type) {
        return PaymentMethodModel(
          type: type,
          title: type.title,
          icon: type.icon,
        );
      }).toList();

  @override
  List<Object?> get props => [type, title];
}
