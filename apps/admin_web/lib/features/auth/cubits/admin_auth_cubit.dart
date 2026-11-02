import 'package:shopease_core/shopease_core.dart';

import 'admin_auth_state.dart';

// Admin Authentication Cubit
class AdminAuthCubit extends Cubit<AdminAuthState> {
  AdminAuthCubit({UserModel? initialUser})
    : super(
        initialUser != null
            ? AdminAuthState(
                status: AdminAuthStatus.authenticated,
                user: initialUser,
              )
            : const AdminAuthState(),
      );

  // Admin login flow
  Future<bool> login(String email, String password) async {
    final cleanEmail = email.trim();
    final cleanPassword = password.trim();

    if (cleanEmail.isEmpty || cleanPassword.isEmpty) {
      emit(
        state.copyWith(
          status: AdminAuthStatus.error,
          errorMessage: 'Please enter both email and password.',
        ),
      );
      return false;
    }

    emit(state.copyWith(status: AdminAuthStatus.loading, clearError: true));

    // Simulated network verification delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Admin email check
    final isAdminEmail =
        cleanEmail.toLowerCase() == mockAdmin.email.toLowerCase() ||
        cleanEmail.toLowerCase() == 'admin@shopease.com';

    if (isAdminEmail) {
      if (cleanPassword == 'admin123' || cleanPassword.length >= 6) {
        emit(
          state.copyWith(
            status: AdminAuthStatus.authenticated,
            user: mockAdmin,
            clearError: true,
          ),
        );
        return true;
      } else {
        emit(
          state.copyWith(
            status: AdminAuthStatus.error,
            errorMessage: 'Invalid password. Minimum 6 characters required.',
          ),
        );
        return false;
      }
    } else {
      emit(
        state.copyWith(
          status: AdminAuthStatus.error,
          errorMessage: 'Invalid email or password. Please check your administrator credentials.',
        ),
      );
      return false;
    }
  }

  // Admin logout
  void logout() {
    emit(const AdminAuthState(status: AdminAuthStatus.unauthenticated));
  }

  // Clear error messages
  void clearError() {
    if (state.errorMessage != null) {
      emit(state.copyWith(clearError: true));
    }
  }
}
