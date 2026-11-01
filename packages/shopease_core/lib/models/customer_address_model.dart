import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

// Delivery and billing address entity
class CustomerAddressModel extends Equatable {
  const CustomerAddressModel({
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.recipientName,
    this.phone,
    this.label,
  });

  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String? recipientName;
  final String? phone;
  final String? label;

  // Formatted one-line display string
  String get formattedAddress {
    final parts = [
      street,
      city,
      state,
      postalCode,
      country,
    ].where((p) => p.isNotEmpty).toList();
    return parts.join(', ');
  }

  // Icon for the address category label
  IconData get tagIcon {
    switch (label?.toLowerCase()) {
      case 'home':
        return IconsaxPlusLinear.home;
      case 'work':
      case 'office':
        return IconsaxPlusLinear.briefcase;
      default:
        return IconsaxPlusLinear.location;
    }
  }

  CustomerAddressModel copyWith({
    String? street,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    String? recipientName,
    String? phone,
    String? label,
  }) {
    return CustomerAddressModel(
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      recipientName: recipientName ?? this.recipientName,
      phone: phone ?? this.phone,
      label: label ?? this.label,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'recipientName': recipientName,
      'phone': phone,
      'label': label,
    };
  }

  factory CustomerAddressModel.fromMap(Map<String, dynamic> map) {
    return CustomerAddressModel(
      street: map['street'] as String? ?? '',
      city: map['city'] as String? ?? '',
      state: map['state'] as String? ?? '',
      postalCode: map['postalCode'] as String? ?? '',
      country: map['country'] as String? ?? '',
      recipientName: map['recipientName'] as String?,
      phone: map['phone'] as String?,
      label: map['label'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    street,
    city,
    state,
    postalCode,
    country,
    recipientName,
    phone,
    label,
  ];
}
