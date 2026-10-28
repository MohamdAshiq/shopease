import 'package:equatable/equatable.dart';

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
  });

  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String? recipientName;
  final String? phone;

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

  CustomerAddressModel copyWith({
    String? street,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    String? recipientName,
    String? phone,
  }) {
    return CustomerAddressModel(
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      recipientName: recipientName ?? this.recipientName,
      phone: phone ?? this.phone,
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
  ];
}
