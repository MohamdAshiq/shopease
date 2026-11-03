import 'package:shopease_core/shopease_core.dart';

import 'profile_state.dart';

// Cubit for managing customer profile & addresses with Firestore synchronization
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    UserModel? initialUser,
    List<CustomerAddressModel>? initialAddresses,
    this.authRepository,
  }) : super(
         ProfileState(
           user: initialUser,
           addresses:
               initialAddresses ??
               (initialUser != null
                   ? (initialUser.addresses.isNotEmpty
                         ? initialUser.addresses
                         : (initialUser.address != null
                               ? [initialUser.address!]
                               : const []))
                   : const []),
           defaultAddressIndex: initialUser?.defaultAddressIndex ?? 0,
         ),
       );

  final AuthRepository? authRepository;

  // Set active user on login or signout
  void setUser(UserModel? user) {
    if (user == null) {
      emit(
        state.copyWith(
          clearUser: true,
          addresses: const [],
          defaultAddressIndex: 0,
        ),
      );
      return;
    }

    final List<CustomerAddressModel> addresses;
    final int defaultIndex;
    if (user.addresses.isNotEmpty) {
      addresses = user.addresses;
      defaultIndex = user.defaultAddressIndex < addresses.length
          ? user.defaultAddressIndex
          : 0;
    } else if (user.address != null) {
      addresses = [user.address!];
      defaultIndex = 0;
    } else {
      addresses = const [];
      defaultIndex = 0;
    }

    emit(
      state.copyWith(
        user: user,
        clearUser: false,
        addresses: addresses,
        defaultAddressIndex: defaultIndex,
      ),
    );
  }

  // Update profile basic info
  void updateProfile({String? displayName, String? email, String? phone}) {
    if (state.user == null) return;
    final updatedUser = state.user!.copyWith(
      displayName: displayName ?? state.user!.displayName,
      email: email ?? state.user!.email,
      phone: phone ?? state.user!.phone,
    );
    emit(state.copyWith(user: updatedUser));
  }

  // Add new delivery address
  void addAddress(CustomerAddressModel address, {bool makeDefault = false}) {
    final updatedList = List<CustomerAddressModel>.from(state.addresses)
      ..add(address);
    final newDefaultIndex = makeDefault
        ? updatedList.length - 1
        : state.defaultAddressIndex;
    emit(
      state.copyWith(
        addresses: updatedList,
        defaultAddressIndex: newDefaultIndex,
      ),
    );
    _syncAddressesToFirestore(updatedList, newDefaultIndex);
  }

  // Update existing address
  void updateAddress(
    int index,
    CustomerAddressModel address, {
    bool? makeDefault,
  }) {
    if (index < 0 || index >= state.addresses.length) return;
    final updatedList = List<CustomerAddressModel>.from(state.addresses);
    updatedList[index] = address;
    int newDefaultIndex = state.defaultAddressIndex;
    if (makeDefault == true) {
      newDefaultIndex = index;
    }
    emit(
      state.copyWith(
        addresses: updatedList,
        defaultAddressIndex: newDefaultIndex,
      ),
    );
    _syncAddressesToFirestore(updatedList, newDefaultIndex);
  }

  // Delete address at index
  void deleteAddress(int index) {
    if (index < 0 || index >= state.addresses.length) return;
    final updatedList = List<CustomerAddressModel>.from(state.addresses)
      ..removeAt(index);
    int newDefaultIndex = state.defaultAddressIndex;
    if (index < state.defaultAddressIndex) {
      newDefaultIndex = state.defaultAddressIndex - 1;
    } else if (index == state.defaultAddressIndex) {
      newDefaultIndex = 0;
    }
    if (newDefaultIndex >= updatedList.length) {
      newDefaultIndex = updatedList.isNotEmpty ? updatedList.length - 1 : 0;
    }
    emit(
      state.copyWith(
        addresses: updatedList,
        defaultAddressIndex: newDefaultIndex,
      ),
    );
    _syncAddressesToFirestore(updatedList, newDefaultIndex);
  }

  // Change default address index
  void setDefaultAddress(int index) {
    if (index < 0 || index >= state.addresses.length) return;
    emit(state.copyWith(defaultAddressIndex: index));
    _syncAddressesToFirestore(state.addresses, index);
  }

  // Toggle push notifications
  void toggleNotifications(bool enabled) {
    emit(state.copyWith(notificationsEnabled: enabled));
  }

  // Background synchronization helper
  Future<void> _syncAddressesToFirestore(
    List<CustomerAddressModel> updatedList,
    int defaultIndex,
  ) async {
    final currentUser = state.user;
    if (authRepository == null || currentUser == null) return;

    try {
      final activeAddress =
          defaultIndex >= 0 && defaultIndex < updatedList.length
          ? updatedList[defaultIndex]
          : (updatedList.isNotEmpty ? updatedList.first : null);

      final updatedUser = currentUser.copyWith(
        addresses: updatedList,
        defaultAddressIndex: defaultIndex,
        address: activeAddress,
        clearAddress: activeAddress == null,
      );
      await authRepository!.updateUserProfile(updatedUser);
    } catch (_) {}
  }
}
