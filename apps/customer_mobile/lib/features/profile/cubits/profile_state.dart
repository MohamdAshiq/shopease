import 'package:shopease_core/shopease_core.dart';

// Profile State
class ProfileState extends Equatable {
  const ProfileState({
    this.user,
    this.addresses = const [],
    this.defaultAddressIndex = 0,
    this.notificationsEnabled = true,
  });

  final UserModel? user;
  final List<CustomerAddressModel> addresses;
  final int defaultAddressIndex;
  final bool notificationsEnabled;

  bool get isAuthenticated => user != null;
  bool get isGuest => user == null;

  // Active default address
  CustomerAddressModel? get defaultAddress {
    if (addresses.isEmpty) return null;
    if (defaultAddressIndex >= 0 && defaultAddressIndex < addresses.length) {
      return addresses[defaultAddressIndex];
    }
    return addresses.first;
  }

  ProfileState copyWith({
    UserModel? user,
    bool clearUser = false,
    List<CustomerAddressModel>? addresses,
    int? defaultAddressIndex,
    bool? notificationsEnabled,
  }) {
    return ProfileState(
      user: clearUser ? null : (user ?? this.user),
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
