import 'dart:async';

import 'package:customer_mobile/features/auth/cubits/auth_cubit.dart';
import 'package:customer_mobile/features/auth/cubits/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopease_core/shopease_core.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthCubit Unit Tests', () {
    late AuthCubit authCubit;

    setUp(() {
      authCubit = AuthCubit(authRepository: _FakeAuthRepository());
    });

    tearDown(() {
      authCubit.close();
    });

    test('initial state defaults to unauthenticated / guest mode', () {
      expect(authCubit.state.status, AuthStatus.unauthenticated);
      expect(authCubit.state.isGuest, isTrue);
      expect(authCubit.state.isAuthenticated, isFalse);
      expect(authCubit.state.user, isNull);
      expect(authCubit.state.errorMessage, isNull);
    });

    test('signIn fails with empty or invalid email', () async {
      final emptyResult = await authCubit.signIn(
        email: '',
        password: 'password123',
      );
      expect(emptyResult, isFalse);
      expect(authCubit.state.hasError, isTrue);
      expect(authCubit.state.errorMessage, contains('email address'));

      final invalidResult = await authCubit.signIn(
        email: 'not-an-email',
        password: 'password123',
      );
      expect(invalidResult, isFalse);
      expect(authCubit.state.hasError, isTrue);
      expect(authCubit.state.errorMessage, contains('valid email'));
    });

    test('signIn fails with password shorter than 6 characters', () async {
      final shortPassResult = await authCubit.signIn(
        email: 'alex@example.com',
        password: '123',
      );
      expect(shortPassResult, isFalse);
      expect(authCubit.state.hasError, isTrue);
      expect(authCubit.state.errorMessage, contains('at least 6 characters'));
    });

    test(
      'signIn succeeds with valid credentials and sets authenticated user',
      () async {
        final success = await authCubit.signIn(
          email: 'alex.smith@example.com',
          password: 'password123',
        );

        expect(success, isTrue);
        expect(authCubit.state.isAuthenticated, isTrue);
        expect(authCubit.state.isGuest, isFalse);
        expect(authCubit.state.user, isNotNull);
        expect(authCubit.state.user?.email, 'alex.smith@example.com');
        expect(authCubit.state.user?.displayName, 'Alex Smith');
      },
    );

    test('signInWithGoogle authenticates user with Google account', () async {
      final success = await authCubit.signInWithGoogle();

      expect(success, isTrue);
      expect(authCubit.state.isAuthenticated, isTrue);
      expect(authCubit.state.user?.email, contains('alex.google'));
    });

    test('register validates name, email and password', () async {
      final noNameResult = await authCubit.register(
        name: '',
        email: 'test@example.com',
        password: 'password123',
      );
      expect(noNameResult, isFalse);
      expect(authCubit.state.errorMessage, contains('full name'));

      final invalidEmailResult = await authCubit.register(
        name: 'John Doe',
        email: 'bad-email',
        password: 'password123',
      );
      expect(invalidEmailResult, isFalse);
      expect(authCubit.state.errorMessage, contains('valid email'));

      final shortPassResult = await authCubit.register(
        name: 'John Doe',
        email: 'john@example.com',
        password: '123',
      );
      expect(shortPassResult, isFalse);
      expect(authCubit.state.errorMessage, contains('6 characters'));
    });

    test('register succeeds with valid details and creates user', () async {
      final success = await authCubit.register(
        name: 'Jane Doe',
        email: 'jane@example.com',
        password: 'password123',
        phone: '+91 91234 56789',
      );

      expect(success, isTrue);
      expect(authCubit.state.isAuthenticated, isTrue);
      expect(authCubit.state.user?.displayName, 'Jane Doe');
      expect(authCubit.state.user?.email, 'jane@example.com');
      expect(authCubit.state.user?.phone, '+91 91234 56789');
    });

    test('signOut resets authenticated user back to guest mode', () async {
      await authCubit.signIn(
        email: 'test@example.com',
        password: 'password123',
      );
      expect(authCubit.state.isAuthenticated, isTrue);

      await authCubit.signOut();
      expect(authCubit.state.isGuest, isTrue);
      expect(authCubit.state.isAuthenticated, isFalse);
      expect(authCubit.state.user, isNull);
    });

    test('resetPassword validates email and sends link', () async {
      final fail = await authCubit.resetPassword(email: 'invalid-email');
      expect(fail, isFalse);
      expect(authCubit.state.hasError, isTrue);

      final success = await authCubit.resetPassword(email: 'valid@example.com');
      expect(success, isTrue);
      expect(authCubit.state.hasError, isFalse);
    });

    test('updateUser modifies active user details', () async {
      await authCubit.signIn(
        email: 'test@example.com',
        password: 'password123',
      );
      final updated = authCubit.state.user!.copyWith(
        displayName: 'Alex Updated',
      );
      authCubit.updateUser(updated);

      expect(authCubit.state.user?.displayName, 'Alex Updated');
    });

    test('clearError resets errorMessage', () async {
      await authCubit.signIn(email: '', password: '');
      expect(authCubit.state.hasError, isTrue);

      authCubit.clearError();
      expect(authCubit.state.hasError, isFalse);
      expect(authCubit.state.errorMessage, isNull);
    });
  });
}

class _FakeAuthRepository implements AuthRepository {
  UserModel? _user;
  final _controller = StreamController<UserModel?>.broadcast();

  @override
  Stream<UserModel?> authStateChanges() => _controller.stream;

  @override
  UserModel? get currentUser => _user;

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final user = UserModel(
      uid: 'test_uid',
      email: email,
      displayName: email.split('@').first.replaceAll('.', ' ').capitalizeWords,
    );
    _user = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<UserModel> registerWithEmail({
    required String name,
    required String email,
    required String password,
    String phone = '',
  }) async {
    final user = UserModel(
      uid: 'test_reg_uid',
      email: email,
      displayName: name,
      phone: phone,
    );
    _user = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    final user = const UserModel(
      uid: 'usr_google_123',
      email: 'alex.google@example.com',
      displayName: 'Alex Morgan',
    );
    _user = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> signOut() async {
    _user = null;
    _controller.add(null);
  }

  @override
  Future<UserModel> updateUserProfile(UserModel user) async {
    _user = user;
    _controller.add(user);
    return user;
  }
}
