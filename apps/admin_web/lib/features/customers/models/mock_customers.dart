import 'package:shopease_core/shopease_core.dart';

import 'customer_view_model.dart';

// Mock Customers List
List<CustomerViewModel> generateMockCustomers(List<OrderModel> orders) {
  final Map<String, List<OrderModel>> ordersByCustomerId = {};
  for (final order in orders) {
    ordersByCustomerId.putIfAbsent(order.customerId, () => []).add(order);
  }

  return [
    CustomerViewModel(
      id: 'cust_101',
      name: 'Alex Morgan',
      email: 'alex.morgan@example.com',
      phone: '+91 98765 43210',
      joinedAt: DateTime(2026, 1, 15),
      address: const CustomerAddressModel(
        street: '742 Evergreen Terrace, Koramangala',
        city: 'Bengaluru',
        state: 'Karnataka',
        postalCode: '560034',
        country: 'India',
        label: 'Home',
      ),
      orders: ordersByCustomerId['cust_101'] ?? const [],
    ),
    CustomerViewModel(
      id: 'cust_102',
      name: 'Priya Sharma',
      email: 'priya.sharma@example.com',
      phone: '+91 98123 45678',
      joinedAt: DateTime(2026, 2, 1),
      address: const CustomerAddressModel(
        street: 'Flat 402, Sea Green Apartments, Bandra West',
        city: 'Mumbai',
        state: 'Maharashtra',
        postalCode: '400050',
        country: 'India',
        label: 'Home',
      ),
      orders: ordersByCustomerId['cust_102'] ?? const [],
    ),
    CustomerViewModel(
      id: 'cust_103',
      name: 'Rahul Verma',
      email: 'rahul.verma@example.com',
      phone: '+91 99887 76655',
      joinedAt: DateTime(2026, 3, 10),
      address: const CustomerAddressModel(
        street: '12B, Connaught Circus',
        city: 'New Delhi',
        state: 'Delhi',
        postalCode: '110001',
        country: 'India',
        label: 'Office',
      ),
      orders: ordersByCustomerId['cust_103'] ?? const [],
    ),
    CustomerViewModel(
      id: 'cust_104',
      name: 'Ananya Patel',
      email: 'ananya.p@example.com',
      phone: '+91 91234 56789',
      joinedAt: DateTime(2026, 9, 20),
      address: const CustomerAddressModel(
        street: '88 Riverfront View, Navrangpura',
        city: 'Ahmedabad',
        state: 'Gujarat',
        postalCode: '380009',
        country: 'India',
        label: 'Home',
      ),
      orders: ordersByCustomerId['cust_104'] ?? const [],
    ),
    CustomerViewModel(
      id: 'cust_105',
      name: 'Vikramaditya Rao',
      email: 'vikram.rao@example.com',
      phone: '+91 98765 00000',
      joinedAt: DateTime(2026, 10, 5),
      address: const CustomerAddressModel(
        street: 'Plot 14, Jubilee Hills, Road No. 36',
        city: 'Hyderabad',
        state: 'Telangana',
        postalCode: '500033',
        country: 'India',
        label: 'Home',
      ),
      orders: ordersByCustomerId['cust_105'] ?? const [],
    ),
    CustomerViewModel(
      id: 'cust_106',
      name: 'Karan Malhotra',
      email: 'karan.m@example.com',
      phone: '+91 97112 33445',
      joinedAt: DateTime(2025, 11, 12),
      address: const CustomerAddressModel(
        street: 'Tower C, Viman Nagar',
        city: 'Pune',
        state: 'Maharashtra',
        postalCode: '411014',
        country: 'India',
        label: 'Home',
      ),
      orders: [
        OrderModel(
          id: 'ORD-2026-7701',
          customerId: 'cust_106',
          customerName: 'Karan Malhotra',
          customerEmail: 'karan.m@example.com',
          customerPhone: '+91 97112 33445',
          items: const [
            OrderItemModel(
              productId: 'prod_mac',
              title: 'MacBook Air M3 15-inch',
              price: 18450.0,
              quantity: 1,
            ),
          ],
          deliveryAddress: const CustomerAddressModel(
            street: 'Tower C, Viman Nagar',
            city: 'Pune',
            state: 'Maharashtra',
            postalCode: '411014',
            country: 'India',
          ),
          subtotal: 18450.0,
          deliveryFee: 0.0,
          total: 18450.0,
          status: 'delivered',
          createdAt: DateTime(2026, 10, 18),
        ),
      ],
    ),
    CustomerViewModel(
      id: 'cust_107',
      name: 'Sneha Sen',
      email: 'sneha.sen@example.com',
      phone: '+91 98301 22334',
      joinedAt: DateTime.now().subtract(const Duration(days: 4)),
      address: const CustomerAddressModel(
        street: 'Block E, Salt Lake City',
        city: 'Kolkata',
        state: 'West Bengal',
        postalCode: '700091',
        country: 'India',
        label: 'Home',
      ),
      orders: const [],
    ),
  ];
}
