import 'package:shopease_core/shopease_core.dart';

// Authentication Status
enum AuthStatus {
  initial,
  unauthenticated, // Guest mode
  loading,
  authenticated,
  failure,
}

// Specific Auth Action being performed
enum AuthAction { none, email, google, resetPassword }

// Authentication State
class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.action = AuthAction.none,
    this.user,
    this.errorMessage,
  });

  final AuthStatus status;
  final AuthAction action;
  final UserModel? user;
  final String? errorMessage;

  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;
  bool get isGuest => !isAuthenticated;
  bool get isLoading => status == AuthStatus.loading;
  bool get isEmailLoading => isLoading && action == AuthAction.email;
  bool get isGoogleLoading => isLoading && action == AuthAction.google;
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  AuthState copyWith({
    AuthStatus? status,
    AuthAction? action,
    UserModel? user,
    bool clearUser = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      action:
          action ??
          (status == AuthStatus.loading ? this.action : AuthAction.none),
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, action, user, errorMessage];
}
