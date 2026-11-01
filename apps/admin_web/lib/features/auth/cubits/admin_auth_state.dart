import 'package:shopease_core/shopease_core.dart';

enum AdminAuthStatus { initial, loading, authenticated, unauthenticated, error }

// Admin Authentication State
class AdminAuthState extends Equatable {
  const AdminAuthState({
    this.status = AdminAuthStatus.unauthenticated,
    this.user,
    this.errorMessage,
  });

  final AdminAuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  bool get isLoading => status == AdminAuthStatus.loading;
  bool get isAuthenticated =>
      status == AdminAuthStatus.authenticated && user != null;
  bool get isAdmin => user?.isAdmin ?? false;

  AdminAuthState copyWith({
    AdminAuthStatus? status,
    UserModel? user,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AdminAuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
