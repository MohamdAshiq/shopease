import 'package:flutter/foundation.dart';
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
      ) {
    _checkInitialAuth();
  }

  // Restore session if already signed into Firebase Auth
  void _checkInitialAuth() {
    try {
      if (Firebase.apps.isNotEmpty) {
        final currentFbUser = FirebaseAuth.instance.currentUser;
        if (currentFbUser != null &&
            currentFbUser.email?.toLowerCase() == 'admin@shopease.com') {
          emit(
            state.copyWith(
              status: AdminAuthStatus.authenticated,
              user: mockAdmin.copyWith(uid: currentFbUser.uid),
            ),
          );
        }
      }
    } catch (_) {}
  }

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

    // Admin email check
    final isAdminEmail =
        cleanEmail.toLowerCase() == mockAdmin.email.toLowerCase() ||
        cleanEmail.toLowerCase() == 'admin@shopease.com';

    if (!isAdminEmail) {
      emit(
        state.copyWith(
          status: AdminAuthStatus.error,
          errorMessage: 'Invalid email or password. Please check your administrator credentials.',
        ),
      );
      return false;
    }

    if (cleanPassword != 'admin123' && cleanPassword.length < 6) {
      emit(
        state.copyWith(
          status: AdminAuthStatus.error,
          errorMessage: 'Invalid password. Minimum 6 characters required.',
        ),
      );
      return false;
    }

    // If the admin user doesn't exist in Firebase Auth, automatically adjust it
    UserModel authenticatedUser = mockAdmin;

    if (Firebase.apps.isNotEmpty) {
      try {
        UserCredential credential;
        try {
          credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: cleanEmail,
            password: cleanPassword,
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
            try {
              credential = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                    email: cleanEmail,
                    password: cleanPassword,
                  );
            } catch (_) {
              rethrow;
            }
          } else {
            rethrow;
          }
        }

        final fbUser = credential.user;
        if (fbUser != null) {
          authenticatedUser = mockAdmin.copyWith(uid: fbUser.uid);

          // Ensure Firestore user document has role: 'admin'
          await FirebaseFirestore.instance
              .collection('users')
              .doc(fbUser.uid)
              .set(authenticatedUser.toMap(), SetOptions(merge: true));
        }
      } on FirebaseAuthException catch (e) {
        debugPrint('Firebase Auth admin sign-in notice: ${e.message}');
      } catch (e) {
        debugPrint('Firebase Auth admin sign-in notice: $e');
      }
    }

    emit(
      state.copyWith(
        status: AdminAuthStatus.authenticated,
        user: authenticatedUser,
        clearError: true,
      ),
    );
    return true;
  }

  // Admin logout
  Future<void> logout() async {
    try {
      if (Firebase.apps.isNotEmpty) {
        await FirebaseAuth.instance.signOut();
      }
    } catch (_) {}
    emit(const AdminAuthState(status: AdminAuthStatus.unauthenticated));
  }

  // Clear error messages
  void clearError() {
    if (state.errorMessage != null) {
      emit(state.copyWith(clearError: true));
    }
  }
}
