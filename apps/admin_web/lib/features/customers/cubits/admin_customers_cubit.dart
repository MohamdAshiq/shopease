import 'dart:async';

import 'package:shopease_core/shopease_core.dart';

import '../models/customer_view_model.dart';
import 'admin_customers_state.dart';

// Cubit managing Customers Module
class AdminCustomersCubit extends Cubit<AdminCustomersState> {
  AdminCustomersCubit({
    OrderRepository? orderRepository,
    FirebaseFirestore? firestore,
    List<CustomerViewModel>? initialCustomers,
  }) : _orderRepository = orderRepository ?? FirestoreOrderRepository(),
       _customFirestore = firestore,
       super(
         AdminCustomersState(
           customers: initialCustomers ?? const [],
           isLoading: initialCustomers == null,
         ),
       );

  final OrderRepository _orderRepository;
  final FirebaseFirestore? _customFirestore;

  FirebaseFirestore get _firestore =>
      _customFirestore ?? FirebaseFirestore.instance;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _usersSubscription;
  StreamSubscription<List<OrderModel>>? _ordersSubscription;

  List<UserModel> _cachedUsers = [];
  List<OrderModel> _cachedOrders = [];

  // Loads live customer accounts and order histories from Firestore
  Future<void> loadCustomers() async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));

    _usersSubscription?.cancel();
    _ordersSubscription?.cancel();

    try {
      // Listen to real-time orders to compute LTV, order count and tiers
      _ordersSubscription = _orderRepository.watchAllOrders().listen(
        (orders) {
          _cachedOrders = orders;
          _recomputeCustomers();
        },
        onError: (e) {
          if (!isClosed) {
            emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
          }
        },
      );

      // Listen to registered users in Firestore
      _usersSubscription = _firestore
          .collection('users')
          .snapshots()
          .listen(
            (snapshot) {
              _cachedUsers = snapshot.docs.map((doc) {
                return UserModel.fromMap(doc.data(), documentId: doc.id);
              }).toList();
              _recomputeCustomers();
            },
            onError: (e) {
              if (!isClosed) {
                emit(
                  state.copyWith(isLoading: false, errorMessage: e.toString()),
                );
              }
            },
          );
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    }
  }

  void _recomputeCustomers() {
    final Map<String, List<OrderModel>> ordersByCustomerId = {};
    final Map<String, List<OrderModel>> ordersByEmail = {};

    for (final order in _cachedOrders) {
      ordersByCustomerId.putIfAbsent(order.customerId, () => []).add(order);
      if (order.customerEmail.isNotEmpty) {
        ordersByEmail
            .putIfAbsent(order.customerEmail.toLowerCase(), () => [])
            .add(order);
      }
    }

    final Set<String> processedCustomerIds = {};
    final Set<String> processedEmails = {};
    final List<CustomerViewModel> customers = [];

    // Map registered users with their live orders
    for (final user in _cachedUsers) {
      processedCustomerIds.add(user.uid);
      if (user.email.isNotEmpty) {
        processedEmails.add(user.email.toLowerCase());
      }

      final matchedOrders = <OrderModel>{
        ...?ordersByCustomerId[user.uid],
        if (user.email.isNotEmpty) ...?ordersByEmail[user.email.toLowerCase()],
      }.toList();

      matchedOrders.sort(
        (a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)),
      );

      final primaryAddress =
          user.defaultAddress ??
          user.address ??
          (user.addresses.isNotEmpty ? user.addresses.first : null);

      customers.add(
        CustomerViewModel(
          id: user.uid,
          name: user.displayName.isNotEmpty
              ? user.displayName
              : (user.email.split('@').first.isNotEmpty
                    ? user.email.split('@').first
                    : 'Shopper'),
          email: user.email,
          phone: user.phone,
          joinedAt: user.createdAt ?? DateTime.now(),
          address: primaryAddress,
          avatarUrl: null,
          orders: matchedOrders,
        ),
      );
    }

    // Guest checkouts not yet associated with registered accounts
    final Map<String, List<OrderModel>> guestOrdersMap = {};
    for (final order in _cachedOrders) {
      final isRegistered =
          processedCustomerIds.contains(order.customerId) ||
          (order.customerEmail.isNotEmpty &&
              processedEmails.contains(order.customerEmail.toLowerCase()));
      if (!isRegistered) {
        final key = order.customerEmail.isNotEmpty
            ? order.customerEmail.toLowerCase()
            : order.customerId;
        guestOrdersMap.putIfAbsent(key, () => []).add(order);
      }
    }

    for (final entry in guestOrdersMap.entries) {
      final guestOrders = entry.value;
      guestOrders.sort(
        (a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)),
      );
      final firstOrder = guestOrders.first;

      customers.add(
        CustomerViewModel(
          id: firstOrder.customerId,
          name: firstOrder.customerName.isNotEmpty
              ? firstOrder.customerName
              : 'Guest Customer',
          email: firstOrder.customerEmail,
          phone: firstOrder.customerPhone,
          joinedAt: guestOrders.last.createdAt ?? DateTime.now(),
          address: firstOrder.deliveryAddress,
          orders: guestOrders,
        ),
      );
    }

    if (!isClosed) {
      emit(
        state.copyWith(
          customers: customers,
          isLoading: false,
          clearErrorMessage: true,
        ),
      );
    }
  }

  // Search filter
  void search(String query) {
    emit(state.copyWith(searchQuery: query, currentPage: 1));
  }

  // Tier filter
  void filterByTier(CustomerTierFilter filter) {
    emit(state.copyWith(tierFilter: filter, currentPage: 1));
  }

  // Sort order
  void changeSort(CustomerSortBy sort) {
    emit(state.copyWith(sortBy: sort, currentPage: 1));
  }

  // Pagination navigation
  void changePage(int page) {
    if (page >= 1 && page <= state.totalPages) {
      emit(state.copyWith(currentPage: page));
    }
  }

  // Select customer for inspector drawer
  void selectCustomer(String? customerId) {
    emit(
      customerId == null
          ? state.copyWith(clearSelectedCustomer: true)
          : state.copyWith(selectedCustomerId: customerId),
    );
  }

  // Close inspector drawer
  void closeDetailsDrawer() {
    emit(state.copyWith(clearSelectedCustomer: true));
  }

  // Reset all search and filter parameters
  void resetFilters() {
    emit(
      state.copyWith(
        searchQuery: '',
        tierFilter: CustomerTierFilter.all,
        sortBy: CustomerSortBy.spendHighToLow,
        currentPage: 1,
      ),
    );
  }

  @override
  Future<void> close() {
    _usersSubscription?.cancel();
    _ordersSubscription?.cancel();
    return super.close();
  }
}
