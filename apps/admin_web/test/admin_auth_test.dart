import 'package:admin_web/features/auth/cubits/admin_auth_cubit.dart';
import 'package:admin_web/features/auth/cubits/admin_auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopease_core/shopease_core.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdminAuthCubit Unit Tests', () {
    late AdminAuthCubit cubit;

    setUp(() {
      cubit = AdminAuthCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state defaults to unauthenticated', () {
      expect(cubit.state.status, AdminAuthStatus.unauthenticated);
      expect(cubit.state.isAuthenticated, isFalse);
      expect(cubit.state.user, isNull);
    });

    test('login with empty credentials fails and emits error', () async {
      final success = await cubit.login('', '');
      expect(success, isFalse);
      expect(cubit.state.status, AdminAuthStatus.error);
      expect(cubit.state.errorMessage, contains('Please enter both'));
    });

    test('login with non-admin email fails and emits error', () async {
      final success = await cubit.login('customer@shopease.com', 'password123');
      expect(success, isFalse);
      expect(cubit.state.status, AdminAuthStatus.error);
      expect(cubit.state.errorMessage, contains('Invalid email or password'));
    });

    test('login with admin email but short password fails', () async {
      final success = await cubit.login('admin@shopease.com', '123');
      expect(success, isFalse);
      expect(cubit.state.status, AdminAuthStatus.error);
      expect(cubit.state.errorMessage, contains('Minimum 6 characters'));
    });

    test(
      'login with valid admin credentials succeeds and sets mockAdmin',
      () async {
        final success = await cubit.login('admin@shopease.com', 'admin123');
        expect(success, isTrue);
        expect(cubit.state.status, AdminAuthStatus.authenticated);
        expect(cubit.state.isAuthenticated, isTrue);
        expect(cubit.state.user, equals(mockAdmin));
        expect(cubit.state.isAdmin, isTrue);
      },
    );

    test('logout resets state to unauthenticated', () async {
      await cubit.login('admin@shopease.com', 'admin123');
      expect(cubit.state.isAuthenticated, isTrue);

      cubit.logout();
      expect(cubit.state.status, AdminAuthStatus.unauthenticated);
      expect(cubit.state.isAuthenticated, isFalse);
      expect(cubit.state.user, isNull);
    });

    test('clearError resets errorMessage', () async {
      await cubit.login('', '');
      expect(cubit.state.errorMessage, isNotNull);

      cubit.clearError();
      expect(cubit.state.errorMessage, isNull);
    });
  });
}
