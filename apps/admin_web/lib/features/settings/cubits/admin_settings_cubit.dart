import 'package:shopease_core/shopease_core.dart';

import 'admin_settings_state.dart';

// Cubit managing admin settings updates
class AdminSettingsCubit extends Cubit<AdminSettingsState> {
  AdminSettingsCubit() : super(const AdminSettingsState());

  // Update store profile information
  Future<void> updateStoreProfile({
    required String storeName,
    required String supportEmail,
    required String phone,
  }) async {
    emit(state.copyWith(isSaving: true));
    await Future<void>.delayed(const Duration(milliseconds: 300));
    emit(
      state.copyWith(
        storeName: storeName.trim(),
        supportEmail: supportEmail.trim(),
        phone: phone.trim(),
        isSaving: false,
      ),
    );
  }
}
