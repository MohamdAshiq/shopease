import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';
import 'auth_repository.dart';

// Firebase implementation of AuthRepository
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _customAuth = auth,
      _customFirestore = firestore {
    if (!kIsWeb) {
      GoogleSignIn.instance.initialize();
    }
  }

  final FirebaseAuth? _customAuth;
  final FirebaseFirestore? _customFirestore;
  FirebaseAuth get _auth => _customAuth ?? FirebaseAuth.instance;
  FirebaseFirestore get _firestore =>
      _customFirestore ?? FirebaseFirestore.instance;
  UserModel? _cachedUser;

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection('users');

  @override
  Stream<UserModel?> authStateChanges() {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        _cachedUser = null;
        return null;
      }
      try {
        final user = await _getOrCreateUserDocument(firebaseUser);
        _cachedUser = user;
        return user;
      } catch (_) {
        final fallback = _fallbackUserModel(firebaseUser);
        _cachedUser = fallback;
        return fallback;
      }
    });
  }

  @override
  UserModel? get currentUser {
    final user = _auth.currentUser;
    if (user == null) {
      _cachedUser = null;
      return null;
    }
    if (_cachedUser != null && _cachedUser!.uid == user.uid) {
      return _cachedUser;
    }
    return _fallbackUserModel(user);
  }

  UserModel _fallbackUserModel(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName?.isNotEmpty == true
          ? user.displayName!
          : (user.email?.split('@').first ?? 'Shopper'),
      phone: user.phoneNumber ?? '',
      role: 'customer',
    );
  }

  Future<UserModel> _getOrCreateUserDocument(
    User firebaseUser, {
    String? preferredDisplayName,
    String? phone,
  }) async {
    final docRef = _usersRef.doc(firebaseUser.uid);
    final snapshot = await docRef.get();

    if (snapshot.exists && snapshot.data() != null) {
      final user = UserModel.fromMap(snapshot.data()!, documentId: snapshot.id);
      _cachedUser = user;
      return user;
    }

    final displayName =
        preferredDisplayName ??
        (firebaseUser.displayName?.isNotEmpty == true
            ? firebaseUser.displayName!
            : (firebaseUser.email?.split('@').first ?? 'Shopper'));

    final user = UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: displayName,
      phone: phone ?? (firebaseUser.phoneNumber ?? ''),
      role: 'customer',
      createdAt: DateTime.now(),
    );

    final data = user.toMap()
      ..['createdAt'] = FieldValue.serverTimestamp()
      ..['updatedAt'] = FieldValue.serverTimestamp();

    await docRef.set(data, SetOptions(merge: true));
    _cachedUser = user;
    return user;
  }

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const AuthException('Login failed: user profile not found.');
      }

      return await _getOrCreateUserDocument(firebaseUser);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_handleAuthException(e));
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserModel> registerWithEmail({
    required String name,
    required String email,
    required String password,
    String phone = '',
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const AuthException(
          'Registration failed: user profile not found.',
        );
      }

      if (name.trim().isNotEmpty) {
        await firebaseUser.updateDisplayName(name.trim());
      }

      return await _getOrCreateUserDocument(
        firebaseUser,
        preferredDisplayName: name.trim(),
        phone: phone.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_handleAuthException(e));
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        final GoogleAuthProvider authProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(authProvider);
      } else {
        final GoogleSignInAccount googleUser = await GoogleSignIn.instance
            .authenticate();
        final GoogleSignInAuthentication googleAuth = googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(credential);
      }

      final user = userCredential.user;
      if (user == null) {
        throw const AuthException('Could not retrieve Google user profile.');
      }

      return await _getOrCreateUserDocument(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'popup-closed-by-user' ||
          e.code == 'cancelled-popup-request') {
        throw const AuthException('Google sign-in was cancelled');
      }
      throw AuthException(_handleAuthException(e));
    } catch (e) {
      if (e is AuthException) rethrow;
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('cancel') ||
          errorStr.contains('12501') ||
          errorStr.contains('popup_closed') ||
          errorStr.contains('closed_by_user') ||
          errorStr.contains('sign_in_canceled') ||
          errorStr.contains('user_cancelled')) {
        throw const AuthException('Google sign-in was cancelled');
      }
      throw AuthException(_cleanErrorMessage(e.toString()));
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_handleAuthException(e));
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    _cachedUser = null;
    try {
      if (!kIsWeb) {
        await GoogleSignIn.instance.signOut();
      }
      await _auth.signOut();
    } catch (_) {
      await _auth.signOut();
    }
  }

  @override
  Future<UserModel> updateUserProfile(UserModel user) async {
    try {
      final docRef = _usersRef.doc(user.uid);
      final data = user.toMap()..['updatedAt'] = FieldValue.serverTimestamp();
      await docRef.set(data, SetOptions(merge: true));

      final currentUser = _auth.currentUser;
      if (currentUser != null && user.displayName.isNotEmpty) {
        await currentUser.updateDisplayName(user.displayName);
      }

      _cachedUser = user;
      return user;
    } on FirebaseException catch (e) {
      throw AuthException(e.message ?? 'Failed to update user profile.');
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password provided is too weak (min. 6 characters).';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'popup-closed-by-user':
      case 'cancelled-popup-request':
        return 'Google sign-in was cancelled';
      default:
        return _cleanErrorMessage(
          e.message ?? 'Authentication error occurred.',
        );
    }
  }

  String _cleanErrorMessage(String error) {
    var cleaned = error.trim();
    if (cleaned.startsWith('Exception: ')) {
      cleaned = cleaned.substring('Exception: '.length);
    }
    final bracketIndex = cleaned.indexOf(']');
    if (cleaned.startsWith('[') && bracketIndex != -1) {
      cleaned = cleaned.substring(bracketIndex + 1).trim();
    }
    return cleaned;
  }
}
