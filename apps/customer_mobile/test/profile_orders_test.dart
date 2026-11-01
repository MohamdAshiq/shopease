import 'package:customer_mobile/features/orders/widgets/order_filter_chips.dart';
import 'package:customer_mobile/features/profile/cubits/profile_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopease_core/shopease_core.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testAddress1 = CustomerAddressModel(
    recipientName: 'Alex Morgan',
    phone: '+91 98765 43210',
    street: '742 Evergreen Terrace',
    city: 'Springfield',
    state: 'OR',
    postalCode: '97477',
    country: 'India',
  );

  const testAddress2 = CustomerAddressModel(
    recipientName: 'Alex Work',
    phone: '+91 98765 43211',
    street: '100 Market St',
    city: 'San Francisco',
    state: 'CA',
    postalCode: '94105',
    country: 'India',
  );

  group('ProfileCubit Unit Tests', () {
    late ProfileCubit profileCubit;

    setUp(() {
      profileCubit = ProfileCubit(
        initialUser: mockCustomer,
        initialAddresses: [testAddress1, testAddress2],
      );
    });

    tearDown(() {
      profileCubit.close();
    });

    test('initial state initializes correctly', () {
      expect(profileCubit.state.user?.displayName, mockCustomer.displayName);
      expect(profileCubit.state.addresses.length, 2);
      expect(profileCubit.state.defaultAddressIndex, 0);
      expect(profileCubit.state.defaultAddress, testAddress1);
      expect(profileCubit.state.notificationsEnabled, isTrue);
    });

    test('updateProfile updates user information', () {
      profileCubit.updateProfile(
        displayName: 'Alexander Morgan',
        phone: '+91 98765 99999',
      );

      expect(profileCubit.state.user?.displayName, 'Alexander Morgan');
      expect(profileCubit.state.user?.phone, '+91 98765 99999');
      expect(profileCubit.state.user?.email, mockCustomer.email);
    });

    test('setUser updates user and can clear to guest', () {
      expect(profileCubit.state.isAuthenticated, isTrue);
      profileCubit.setUser(null);
      expect(profileCubit.state.isGuest, isTrue);
      expect(profileCubit.state.user, isNull);

      profileCubit.setUser(mockCustomer);
      expect(profileCubit.state.isAuthenticated, isTrue);
      expect(profileCubit.state.user?.displayName, mockCustomer.displayName);
    });

    test('addAddress appends address and can set as default', () {
      const newAddress = CustomerAddressModel(
        recipientName: 'Vacation Home',
        phone: '+91 98765 77777',
        street: '45 Ocean Drive',
        city: 'Miami',
        state: 'FL',
        postalCode: '33139',
        country: 'India',
      );

      profileCubit.addAddress(newAddress, makeDefault: true);

      expect(profileCubit.state.addresses.length, 3);
      expect(profileCubit.state.addresses.last.recipientName, 'Vacation Home');
      expect(profileCubit.state.defaultAddressIndex, 2);
      expect(profileCubit.state.defaultAddress, newAddress);
    });

    test('updateAddress modifies address at specified index', () {
      final updated = testAddress1.copyWith(street: '744 Evergreen Terrace');
      profileCubit.updateAddress(0, updated);

      expect(profileCubit.state.addresses[0].street, '744 Evergreen Terrace');
    });

    test('deleteAddress removes address and adjusts default index', () {
      profileCubit.deleteAddress(0);

      expect(profileCubit.state.addresses.length, 1);
      expect(profileCubit.state.addresses.first, testAddress2);
      expect(profileCubit.state.defaultAddressIndex, 0);
    });

    test('deleteAddress when deleting before default index shifts default index left', () {
      profileCubit.setDefaultAddress(1);
      expect(profileCubit.state.defaultAddressIndex, 1);
      expect(profileCubit.state.defaultAddress, testAddress2);

      profileCubit.deleteAddress(0);
      expect(profileCubit.state.addresses.length, 1);
      expect(profileCubit.state.defaultAddressIndex, 0);
      expect(profileCubit.state.defaultAddress, testAddress2);
    });

    test('setDefaultAddress changes active default address', () {
      profileCubit.setDefaultAddress(1);

      expect(profileCubit.state.defaultAddressIndex, 1);
      expect(profileCubit.state.defaultAddress, testAddress2);
    });

    test('toggleNotifications updates state', () {
      profileCubit.toggleNotifications(false);
      expect(profileCubit.state.notificationsEnabled, isFalse);
    });
  });

  group('OrderFilterType Unit Tests', () {
    final pendingOrder = mockOrders.first.copyWith(status: 'pending');
    final processingOrder = mockOrders.first.copyWith(status: 'processing');
    final shippedOrder = mockOrders.first.copyWith(status: 'shipped');
    final deliveredOrder = mockOrders.first.copyWith(status: 'delivered');
    final cancelledOrder = mockOrders.first.copyWith(status: 'cancelled');

    test('all filter matches all orders', () {
      expect(OrderFilterType.all.matches(pendingOrder), isTrue);
      expect(OrderFilterType.all.matches(deliveredOrder), isTrue);
      expect(OrderFilterType.all.matches(cancelledOrder), isTrue);
    });

    test('inProgress filter matches pending, processing and shipped', () {
      expect(OrderFilterType.inProgress.matches(pendingOrder), isTrue);
      expect(OrderFilterType.inProgress.matches(processingOrder), isTrue);
      expect(OrderFilterType.inProgress.matches(shippedOrder), isTrue);
      expect(OrderFilterType.inProgress.matches(deliveredOrder), isFalse);
      expect(OrderFilterType.inProgress.matches(cancelledOrder), isFalse);
    });

    test('delivered and cancelled filters match specific status', () {
      expect(OrderFilterType.delivered.matches(deliveredOrder), isTrue);
      expect(OrderFilterType.delivered.matches(pendingOrder), isFalse);

      expect(OrderFilterType.cancelled.matches(cancelledOrder), isTrue);
      expect(OrderFilterType.cancelled.matches(deliveredOrder), isFalse);
    });
  });
}
