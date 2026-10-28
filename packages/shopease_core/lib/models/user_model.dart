import 'package:equatable/equatable.dart';

import 'customer_address_model.dart';

// User profile entity
class UserModel extends Equatable {
  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.role = 'customer',
    this.phone = '',
    this.address,
    this.createdAt,
  });

  final String uid;
  final String email;
  final String displayName;
  final String role;
  final String phone;
  final CustomerAddressModel? address;
  final DateTime? createdAt;

  // Role checks
  bool get isAdmin => role == 'admin';
  bool get isCustomer => role == 'customer';

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? role,
    String? phone,
    CustomerAddressModel? address,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role,
      'phone': phone,
      'address': address?.toMap(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    DateTime? parseDate(dynamic date) {
      if (date == null) return null;
      if (date is DateTime) return date;
      if (date is String) return DateTime.tryParse(date);
      try {
        final dynamic ts = date;
        return ts.toDate() as DateTime;
      } catch (_) {
        return null;
      }
    }

    return UserModel(
      uid: documentId ?? (map['uid'] as String? ?? ''),
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String? ?? '',
      role: map['role'] as String? ?? 'customer',
      phone: map['phone'] as String? ?? '',
      address: map['address'] != null && map['address'] is Map<String, dynamic>
          ? CustomerAddressModel.fromMap(map['address'] as Map<String, dynamic>)
          : null,
      createdAt: parseDate(map['createdAt']),
    );
  }

  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    role,
    phone,
    address,
    createdAt,
  ];
}

// Mock Customer
final mockCustomer = UserModel(
  uid: 'usr_cust_001',
  email: 'customer@shopease.com',
  displayName: 'Alex Morgan',
  role: 'customer',
  phone: '+1 555-0199',
  address: const CustomerAddressModel(
    street: '742 Evergreen Terrace',
    city: 'Springfield',
    state: 'OR',
    postalCode: '97477',
    country: 'USA',
    recipientName: 'Alex Morgan',
    phone: '9876543210',
  ),
  createdAt: DateTime(2026, 1, 10),
);

// Mock Admin
final mockAdmin = UserModel(
  uid: 'usr_admin_001',
  email: 'admin@shopease.com',
  displayName: 'Store Manager',
  role: 'admin',
  phone: '9876543201',
  createdAt: DateTime(2026, 1, 1),
);
