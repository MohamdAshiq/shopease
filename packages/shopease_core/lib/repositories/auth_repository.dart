import '../models/user_model.dart';

// Exception thrown on authentication errors
class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

abstract class AuthRepository {
  // Stream of auth state changes
  Stream<UserModel?> authStateChanges();

  // Currently authenticated user in local memory
  UserModel? get currentUser;

  // Sign in with email and password
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });

  // Register a new user
  Future<UserModel> registerWithEmail({
    required String name,
    required String email,
    required String password,
    String phone = '',
  });

  // Sign in using Google OAuth
  Future<UserModel> signInWithGoogle();

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email);

  // Sign out current user
  Future<void> signOut();

  // Update profile details for a user
  Future<UserModel> updateUserProfile(UserModel user);
}
