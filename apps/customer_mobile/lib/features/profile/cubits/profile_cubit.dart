import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease_core/shopease_core.dart';

import 'profile_state.dart';

// Cubit for managing customer profile
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    UserModel? initialUser,
    List<CustomerAddressModel>? initialAddresses,
  }) : super(
         ProfileState(
           user: initialUser,
           addresses:
               initialAddresses ??
               (initialUser != null
                   ? ProfileState.defaultStarterAddresses
                   : const []),
         ),
       );

  // Set active user on login or signout
  void setUser(UserModel? user) {
    emit(
      state.copyWith(
        user: user,
        clearUser: user == null,
        addresses: user != null
            ? (state.addresses.isNotEmpty
                  ? state.addresses
                  : ProfileState.defaultStarterAddresses)
            : const [],
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
  }

  // Change default address index
  void setDefaultAddress(int index) {
    if (index < 0 || index >= state.addresses.length) return;
    emit(state.copyWith(defaultAddressIndex: index));
  }

  // Toggle push notifications
  void toggleNotifications(bool enabled) {
    emit(state.copyWith(notificationsEnabled: enabled));
  }
}
