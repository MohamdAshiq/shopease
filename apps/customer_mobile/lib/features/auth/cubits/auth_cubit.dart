import 'dart:async';

import 'package:shopease_core/shopease_core.dart';

import 'auth_state.dart';

// Authentication Cubit managing customer sessions with Firebase Auth
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    AuthRepository? authRepository,
    AuthState? initialState,
    this.onUserChanged,
  }) : _authRepository = authRepository ?? FirebaseAuthRepository(),
       super(
         initialState ?? const AuthState(status: AuthStatus.unauthenticated),
       ) {
    _initAuthListener();
  }

  final AuthRepository _authRepository;
  final void Function(UserModel? user)? onUserChanged;
  StreamSubscription<UserModel?>? _authSubscription;

  bool get isAuthenticated => state.isAuthenticated;
  bool get isGuest => state.isGuest;
  UserModel? get currentUser => state.user;

  void _initAuthListener() {
    _authSubscription = _authRepository.authStateChanges().listen((user) {
      if (user != null) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            clearError: true,
          ),
        );
        onUserChanged?.call(user);
      } else {
        // If the session was revoked or signed out remotely
        if (state.status == AuthStatus.authenticated) {
          emit(const AuthState(status: AuthStatus.unauthenticated));
          onUserChanged?.call(null);
        }
      }
    });
  }

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

    emit(
      state.copyWith(
        status: AuthStatus.loading,
        action: AuthAction.email,
        clearError: true,
      ),
    );

    try {
      final user = await _authRepository.signInWithEmail(
        email: trimmedEmail,
        password: trimmedPass,
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
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: e is AuthException ? e.message : e.toString(),
        ),
      );
      return false;
    }
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

    emit(
      state.copyWith(
        status: AuthStatus.loading,
        action: AuthAction.email,
        clearError: true,
      ),
    );

    try {
      final newUser = await _authRepository.registerWithEmail(
        name: trimmedName,
        email: trimmedEmail,
        password: trimmedPass,
        phone: trimmedPhone,
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
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: e is AuthException ? e.message : e.toString(),
        ),
      );
      return false;
    }
  }

  // Sign In with Google
  Future<bool> signInWithGoogle() async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        action: AuthAction.google,
        clearError: true,
      ),
    );

    try {
      final user = await _authRepository.signInWithGoogle();
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          clearError: true,
        ),
      );
      onUserChanged?.call(user);
      return true;
    } catch (e) {
      var message = e is AuthException ? e.message : e.toString();
      final lower = message.toLowerCase();
      if (lower.contains('cancel') ||
          lower.contains('12501') ||
          lower.contains('sign_in_canceled') ||
          lower.contains('closed_by_user')) {
        message = 'Google sign-in was cancelled';
      }
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: message));
      return false;
    }
  }

  // Quick Sign In for testing
  Future<void> signInWithMock() async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        action: AuthAction.resetPassword,
        clearError: true,
      ),
    );
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

  // Sign out
  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
    } catch (_) {}
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

    emit(
      state.copyWith(
        status: AuthStatus.loading,
        action: AuthAction.resetPassword,
        clearError: true,
      ),
    );

    try {
      await _authRepository.sendPasswordResetEmail(trimmedEmail);
      emit(
        state.copyWith(status: AuthStatus.unauthenticated, clearError: true),
      );
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: e is AuthException ? e.message : e.toString(),
        ),
      );
      return false;
    }
  }

  // Update authenticated user profile details
  Future<void> updateUser(UserModel updatedUser) async {
    if (state.isAuthenticated) {
      try {
        final synced = await _authRepository.updateUserProfile(updatedUser);
        emit(state.copyWith(user: synced));
        onUserChanged?.call(synced);
      } catch (_) {
        emit(state.copyWith(user: updatedUser));
        onUserChanged?.call(updatedUser);
      }
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

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
