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
    this.addresses = const [],
    this.defaultAddressIndex = 0,
    this.createdAt,
  });

  final String uid;
  final String email;
  final String displayName;
  final String role;
  final String phone;
  final CustomerAddressModel? address;
  final List<CustomerAddressModel> addresses;
  final int defaultAddressIndex;
  final DateTime? createdAt;

  // Role checks
  bool get isAdmin => role == 'admin';
  bool get isCustomer => role == 'customer';

  // Active default address
  CustomerAddressModel? get defaultAddress {
    if (addresses.isNotEmpty) {
      if (defaultAddressIndex >= 0 && defaultAddressIndex < addresses.length) {
        return addresses[defaultAddressIndex];
      }
      return addresses.first;
    }
    return address;
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? role,
    String? phone,
    CustomerAddressModel? address,
    bool clearAddress = false,
    List<CustomerAddressModel>? addresses,
    int? defaultAddressIndex,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      address: clearAddress ? null : (address ?? this.address),
      addresses: addresses ?? this.addresses,
      defaultAddressIndex: defaultAddressIndex ?? this.defaultAddressIndex,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final activeAddress = defaultAddress;
    final map = <String, dynamic>{
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role,
      'phone': phone,
      'defaultAddressIndex': defaultAddressIndex,
    };
    if (activeAddress != null) {
      map['address'] = activeAddress.toMap();
    }
    if (addresses.isNotEmpty) {
      map['addresses'] = addresses.map((a) => a.toMap()).toList();
    }
    if (createdAt != null) {
      map['createdAt'] = createdAt!.toIso8601String();
    }
    return map;
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

    final rawAddresses = map['addresses'] as List<dynamic>? ?? const [];
    final parsedAddresses = rawAddresses
        .whereType<Map<String, dynamic>>()
        .map(CustomerAddressModel.fromMap)
        .toList();

    CustomerAddressModel? addr;
    if (map['address'] != null && map['address'] is Map<String, dynamic>) {
      addr = CustomerAddressModel.fromMap(
        map['address'] as Map<String, dynamic>,
      );
    } else if (parsedAddresses.isNotEmpty) {
      addr = parsedAddresses.first;
    }

    final defaultIdx = (map['defaultAddressIndex'] as num?)?.toInt() ?? 0;

    return UserModel(
      uid: documentId ?? (map['uid'] as String? ?? ''),
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String? ?? '',
      role: map['role'] as String? ?? 'customer',
      phone: map['phone'] as String? ?? '',
      address: addr,
      addresses: parsedAddresses.isNotEmpty
          ? parsedAddresses
          : (addr != null ? [addr] : const []),
      defaultAddressIndex: defaultIdx,
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
    addresses,
    defaultAddressIndex,
    createdAt,
  ];
}

// Mock Customer (Testing)
final mockCustomer = UserModel(
  uid: 'usr_cust_001',
  email: 'customer@shopease.com',
  displayName: 'Alex Morgan',
  role: 'customer',
  phone: '+91 98765 43210',
  address: const CustomerAddressModel(
    street: '742 Evergreen Terrace',
    city: 'Springfield',
    state: 'OR',
    postalCode: '97477',
    country: 'India',
    recipientName: 'Alex Morgan',
    phone: '+91 98765 43210',
    label: 'Home',
  ),
  addresses: const [
    CustomerAddressModel(
      street: '742 Evergreen Terrace',
      city: 'Springfield',
      state: 'OR',
      postalCode: '97477',
      country: 'India',
      recipientName: 'Alex Morgan',
      phone: '+91 98765 43210',
      label: 'Home',
    ),
  ],
  defaultAddressIndex: 0,
  createdAt: DateTime(2026, 1, 10),
);

// Mock Admin (Testing)
final mockAdmin = UserModel(
  uid: 'usr_admin_001',
  email: 'admin@shopease.com',
  displayName: 'ShopEase Admin',
  role: 'admin',
  phone: '+91 98765 43201',
  createdAt: DateTime(2026, 1, 1),
);
