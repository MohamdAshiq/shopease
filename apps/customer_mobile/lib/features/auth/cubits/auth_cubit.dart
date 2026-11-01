import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease_core/shopease_core.dart';

import 'auth_state.dart';

// Authentication Cubit
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({AuthState? initialState, this.onUserChanged})
    : super(
        initialState ?? const AuthState(status: AuthStatus.unauthenticated),
      );

  final void Function(UserModel? user)? onUserChanged;

  bool get isAuthenticated => state.isAuthenticated;
  bool get isGuest => state.isGuest;
  UserModel? get currentUser => state.user;

  // Sign In with email and password
  Future<bool> signIn({required String email, required String password}) async {
    final trimmedEmail = email.trim();
    final trimmedPass = password.trim();

    final emailError = AppValidators.validateEmail(trimmedEmail);
    if (emailError != null) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: emailError),
      );
      return false;
    }

    final passError = AppValidators.validatePassword(trimmedPass);
    if (passError != null) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: passError));
      return false;
    }

    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    // Simulated network authentication delay
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final user =
        (trimmedEmail.toLowerCase() == mockCustomer.email.toLowerCase())
        ? mockCustomer
        : UserModel(
            uid: 'usr_${DateTime.now().millisecondsSinceEpoch}',
            email: trimmedEmail,
            displayName: trimmedEmail
                .split('@')
                .first
                .replaceAll('.', ' ')
                .capitalizeWords,
            phone: '+91 98765 43210',
            address: mockCustomer.address,
            createdAt: DateTime.now(),
          );

    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        clearError: true,
      ),
    );
    onUserChanged?.call(user);
    return true;
  }

  // Register a new account
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String phone = '',
  }) async {
    final trimmedName = name.trim();
    final trimmedEmail = email.trim();
    final trimmedPass = password.trim();
    final trimmedPhone = phone.trim();

    final nameError = AppValidators.validateRequired(trimmedName, 'full name');
    if (nameError != null) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: nameError));
      return false;
    }

    final emailError = AppValidators.validateEmail(trimmedEmail);
    if (emailError != null) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: emailError),
      );
      return false;
    }

    final passError = AppValidators.validatePassword(trimmedPass);
    if (passError != null) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: passError));
      return false;
    }

    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    await Future<void>.delayed(const Duration(milliseconds: 300));

    final newUser = UserModel(
      uid: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      email: trimmedEmail,
      displayName: trimmedName,
      phone: trimmedPhone.isNotEmpty ? trimmedPhone : '+91 98765 00000',
      createdAt: DateTime.now(),
    );

    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        user: newUser,
        clearError: true,
      ),
    );
    onUserChanged?.call(newUser);
    return true;
  }

  // Sign In with Google
  Future<bool> signInWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    await Future<void>.delayed(const Duration(milliseconds: 350));

    final googleUser = UserModel(
      uid: 'usr_google_${DateTime.now().millisecondsSinceEpoch}',
      email: 'alex.google@example.com',
      displayName: 'Alex Morgan',
      phone: '+91 98765 43210',
      address: mockCustomer.address,
      createdAt: DateTime.now(),
    );

    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        user: googleUser,
        clearError: true,
      ),
    );
    onUserChanged?.call(googleUser);
    return true;
  }

  // Quick Sign In=
  Future<void> signInWithMock() async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    await Future<void>.delayed(const Duration(milliseconds: 200));
    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        user: mockCustomer,
        clearError: true,
      ),
    );
    onUserChanged?.call(mockCustomer);
  }

  // Sign out and reset to guest
  Future<void> signOut() async {
    emit(const AuthState(status: AuthStatus.unauthenticated));
    onUserChanged?.call(null);
  }

  // Request password reset
  Future<bool> resetPassword({required String email}) async {
    final trimmedEmail = email.trim();
    final emailError = AppValidators.validateEmail(trimmedEmail);
    if (emailError != null) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: emailError),
      );
      return false;
    }

    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    await Future<void>.delayed(const Duration(milliseconds: 300));
    emit(state.copyWith(status: AuthStatus.unauthenticated, clearError: true));
    return true;
  }

  // Update authenticated user profile details
  void updateUser(UserModel updatedUser) {
    if (state.isAuthenticated) {
      emit(state.copyWith(user: updatedUser));
      onUserChanged?.call(updatedUser);
    }
  }

  // Continue as guest
  void continueAsGuest() {
    emit(const AuthState(status: AuthStatus.unauthenticated));
    onUserChanged?.call(null);
  }

  // Clear any existing error messages
  void clearError() {
    if (state.hasError) {
      emit(state.copyWith(clearError: true));
    }
  }
}
