import 'package:shopease_core/shopease_core.dart';

// Profile State
class ProfileState extends Equatable {
  const ProfileState({
    required this.user,
    required this.addresses,
    this.defaultAddressIndex = 0,
    this.notificationsEnabled = true,
  });

  final UserModel user;
  final List<CustomerAddressModel> addresses;
  final int defaultAddressIndex;
  final bool notificationsEnabled;

  // Active default address
  CustomerAddressModel? get defaultAddress {
    if (addresses.isEmpty) return null;
    if (defaultAddressIndex >= 0 && defaultAddressIndex < addresses.length) {
      return addresses[defaultAddressIndex];
    }
    return addresses.first;
  }

  // Starter Addresses
  static final List<CustomerAddressModel> defaultStarterAddresses = [
    if (mockCustomer.address != null) mockCustomer.address!,
    const CustomerAddressModel(
      recipientName: 'Alex Morgan',
      phone: '+91 98765 43211',
      street: '100 Market St, Suite 400',
      city: 'San Francisco',
      state: 'CA',
      postalCode: '94105',
      country: 'India',
      label: 'Work',
    ),
  ];

  ProfileState copyWith({
    UserModel? user,
    List<CustomerAddressModel>? addresses,
    int? defaultAddressIndex,
    bool? notificationsEnabled,
  }) {
    return ProfileState(
      user: user ?? this.user,
      addresses: addresses ?? this.addresses,
      defaultAddressIndex: defaultAddressIndex ?? this.defaultAddressIndex,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  List<Object?> get props => [
    user,
    addresses,
    defaultAddressIndex,
    notificationsEnabled,
  ];
}
