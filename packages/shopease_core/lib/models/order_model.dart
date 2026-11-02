import 'package:equatable/equatable.dart';

import '../constants/order_status.dart';
import 'customer_address_model.dart';
import 'order_item_model.dart';
import 'payment_method_model.dart';

// Order Entity
class OrderModel extends Equatable {
  const OrderModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.items,
    required this.deliveryAddress,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    this.customerPhone = '',
    this.paymentMethod = PaymentMethodType.upi,
    this.status = 'pending',
    this.statusHistory = const [],
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String customerId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final PaymentMethodType paymentMethod;
  final List<OrderItemModel> items;
  final CustomerAddressModel deliveryAddress;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String status;
  final List<OrderStatusHistory> statusHistory;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderStatus get orderStatus => OrderStatus.fromString(status);

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  OrderModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    PaymentMethodType? paymentMethod,
    List<OrderItemModel>? items,
    CustomerAddressModel? deliveryAddress,
    double? subtotal,
    double? deliveryFee,
    double? total,
    String? status,
    List<OrderStatusHistory>? statusHistory,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      items: items ?? this.items,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      status: status ?? this.status,
      statusHistory: statusHistory ?? this.statusHistory,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'paymentMethod': paymentMethod.name,
      'items': items.map((i) => i.toMap()).toList(),
      'deliveryAddress': deliveryAddress.toMap(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'status': status,
      'statusHistory': statusHistory.map((h) => h.toMap()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    DateTime? parseDate(dynamic date) {
      if (date == null) return null;
      if (date is DateTime) return date;
      if (date is String) return DateTime.tryParse(date);
      try {
        final dynamic ts = date;
        return ts.toDate() as DateTime;
      } catch (_) {
        return null;
      }
    }

    final rawItems = map['items'] as List<dynamic>? ?? const [];
    final rawHistory = map['statusHistory'] as List<dynamic>? ?? const [];

    return OrderModel(
      id: documentId ?? (map['id'] as String? ?? ''),
      customerId: map['customerId'] as String? ?? '',
      customerName: map['customerName'] as String? ?? '',
      customerEmail: map['customerEmail'] as String? ?? '',
      customerPhone: map['customerPhone'] as String? ?? '',
      paymentMethod: PaymentMethodType.fromString(
        map['paymentMethod'] as String?,
      ),
      items: rawItems
          .map((i) => OrderItemModel.fromMap(i as Map<String, dynamic>))
          .toList(),
      deliveryAddress: map['deliveryAddress'] != null
          ? CustomerAddressModel.fromMap(
              map['deliveryAddress'] as Map<String, dynamic>,
            )
          : const CustomerAddressModel(
              street: '',
              city: '',
              state: '',
              postalCode: '',
              country: '',
            ),
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (map['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] as String? ?? 'pending',
      statusHistory: rawHistory
          .map((h) => OrderStatusHistory.fromMap(h as Map<String, dynamic>))
          .toList(),
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    customerId,
    customerName,
    customerEmail,
    customerPhone,
    paymentMethod,
    items,
    deliveryAddress,
    subtotal,
    deliveryFee,
    total,
    status,
    statusHistory,
    createdAt,
    updatedAt,
  ];
}

// Order Status History Timeline
class OrderStatusHistory extends Equatable {
  const OrderStatusHistory({
    required this.status,
    required this.timestamp,
    this.note,
  });

  final String status;
  final DateTime timestamp;
  final String? note;

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      'note': note,
    };
  }

  factory OrderStatusHistory.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic date) {
      if (date is DateTime) return date;
      if (date is String) return DateTime.tryParse(date) ?? DateTime.now();
      try {
        final dynamic ts = date;
        return ts.toDate() as DateTime;
      } catch (_) {
        return DateTime.now();
      }
    }

    return OrderStatusHistory(
      status: map['status'] as String? ?? 'pending',
      timestamp: parseDate(map['timestamp']),
      note: map['note'] as String?,
    );
  }

  @override
  List<Object?> get props => [status, timestamp, note];
}

// Mock Orders List
final List<OrderModel> mockOrders = [
  OrderModel(
    id: 'ORD-20261028-1001',
    customerId: 'usr_cust_001',
    customerName: 'Alex Morgan',
    customerEmail: 'customer@shopease.com',
    customerPhone: '+91 98765 43210',
    items: const [
      OrderItemModel(
        productId: 'prod_001',
        title: 'Sony WH-1000XM5 Wireless Headphones',
        price: 349.99,
        quantity: 1,
        imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&q=80',
      ),
      OrderItemModel(
        productId: 'prod_004',
        title: 'Ergonomic Mechanical Keyboard',
        price: 129.00,
        quantity: 1,
        imageUrl: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=800&q=80',
      ),
    ],
    deliveryAddress: const CustomerAddressModel(
      street: '742 Evergreen Terrace',
      city: 'Springfield',
      state: 'OR',
      postalCode: '97477',
      country: 'USA',
      recipientName: 'Alex Morgan',
      phone: '+91 98765 43210',
    ),
    subtotal: 478.99,
    deliveryFee: 15.00,
    total: 493.99,
    paymentMethod: PaymentMethodType.upi,
    status: 'processing',
    statusHistory: [
      OrderStatusHistory(
        status: 'pending',
        timestamp: DateTime(2026, 10, 28, 9, 30),
        note: 'Order placed by customer',
      ),
      OrderStatusHistory(
        status: 'processing',
        timestamp: DateTime(2026, 10, 28, 10, 15),
        note: 'Payment verified and items packed',
      ),
    ],
    createdAt: DateTime(2026, 10, 28, 9, 30),
    updatedAt: DateTime(2026, 10, 28, 10, 15),
  ),
  OrderModel(
    id: 'ORD-20261027-0982',
    customerId: 'usr_cust_001',
    customerName: 'Alex Morgan',
    customerEmail: 'customer@shopease.com',
    customerPhone: '+91 98765 43210',
    items: const [
      OrderItemModel(
        productId: 'prod_002',
        title: 'Nike Air Max Pulse Sneakers',
        price: 149.99,
        quantity: 1,
        imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&q=80',
      ),
    ],
    deliveryAddress: const CustomerAddressModel(
      street: '742 Evergreen Terrace',
      city: 'Springfield',
      state: 'OR',
      postalCode: '97477',
      country: 'USA',
      recipientName: 'Alex Morgan',
      phone: '+91 98765 43210',
    ),
    subtotal: 149.99,
    deliveryFee: 10.00,
    total: 159.99,
    paymentMethod: PaymentMethodType.upi,
    status: 'delivered',
    statusHistory: [
      OrderStatusHistory(
        status: 'pending',
        timestamp: DateTime(2026, 10, 25, 14, 0),
      ),
      OrderStatusHistory(
        status: 'processing',
        timestamp: DateTime(2026, 10, 25, 15, 30),
      ),
      OrderStatusHistory(
        status: 'shipped',
        timestamp: DateTime(2026, 10, 26, 8, 45),
      ),
      OrderStatusHistory(
        status: 'delivered',
        timestamp: DateTime(2026, 10, 27, 11, 20),
        note: 'Package signed for by recipient',
      ),
    ],
    createdAt: DateTime(2026, 10, 25, 14, 0),
    updatedAt: DateTime(2026, 10, 27, 11, 20),
  ),
  OrderModel(
    id: 'ORD-20261029-1045',
    customerId: 'usr_cust_002',
    customerName: 'Priya Sharma',
    customerEmail: 'priya.sharma@example.com',
    customerPhone: '+91 98112 23344',
    items: const [
      OrderItemModel(
        productId: 'prod_005',
        title: 'Minimalist Ceramic Coffee Mug',
        price: 24.99,
        quantity: 2,
        imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=800&q=80',
      ),
      OrderItemModel(
        productId: 'prod_003',
        title: 'Classic Cotton Crewneck T-Shirt',
        price: 29.99,
        quantity: 1,
        imageUrl: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=800&q=80',
      ),
    ],
    deliveryAddress: const CustomerAddressModel(
      street: '12B Green Park Extension',
      city: 'New Delhi',
      state: 'DL',
      postalCode: '110016',
      country: 'India',
      recipientName: 'Priya Sharma',
      phone: '+91 98112 23344',
    ),
    subtotal: 79.97,
    deliveryFee: 5.00,
    total: 84.97,
    paymentMethod: PaymentMethodType.card,
    status: 'pending',
    statusHistory: [
      OrderStatusHistory(
        status: 'pending',
        timestamp: DateTime(2026, 10, 29, 8, 15),
        note: 'Order placed, awaiting confirmation',
      ),
    ],
    createdAt: DateTime(2026, 10, 29, 8, 15),
    updatedAt: DateTime(2026, 10, 29, 8, 15),
  ),
  OrderModel(
    id: 'ORD-20261028-1012',
    customerId: 'usr_cust_003',
    customerName: 'Rahul Verma',
    customerEmail: 'rahul.v@example.com',
    customerPhone: '+91 99887 76655',
    items: const [
      OrderItemModel(
        productId: 'prod_006',
        title: 'Apple Watch Series 9 GPS',
        price: 399.00,
        quantity: 1,
        imageUrl: 'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=800&q=80',
      ),
    ],
    deliveryAddress: const CustomerAddressModel(
      street: '45 Koramangala 4th Block',
      city: 'Bengaluru',
      state: 'KA',
      postalCode: '560034',
      country: 'India',
      recipientName: 'Rahul Verma',
      phone: '+91 99887 76655',
    ),
    subtotal: 399.00,
    deliveryFee: 0.00,
    total: 399.00,
    paymentMethod: PaymentMethodType.upi,
    status: 'shipped',
    statusHistory: [
      OrderStatusHistory(
        status: 'pending',
        timestamp: DateTime(2026, 10, 28, 11, 0),
      ),
      OrderStatusHistory(
        status: 'processing',
        timestamp: DateTime(2026, 10, 28, 13, 30),
      ),
      OrderStatusHistory(
        status: 'shipped',
        timestamp: DateTime(2026, 10, 29, 6, 45),
        note: 'Dispatched via Express Courier (Tracking: EXP-99821)',
      ),
    ],
    createdAt: DateTime(2026, 10, 28, 11, 0),
    updatedAt: DateTime(2026, 10, 29, 6, 45),
  ),
  OrderModel(
    id: 'ORD-20261026-0955',
    customerId: 'usr_cust_004',
    customerName: 'Sarah Jenkins',
    customerEmail: 'sarah.j@example.com',
    customerPhone: '+1 555 019 2834',
    items: const [
      OrderItemModel(
        productId: 'prod_007',
        title: 'Pro Gaming Controller Wireless',
        price: 69.99,
        quantity: 1,
        imageUrl: 'https://images.unsplash.com/photo-1600080972464-8e5f35f63d08?w=800&q=80',
      ),
    ],
    deliveryAddress: const CustomerAddressModel(
      street: '512 Sunset Boulevard',
      city: 'Los Angeles',
      state: 'CA',
      postalCode: '90028',
      country: 'USA',
      recipientName: 'Sarah Jenkins',
      phone: '+1 555 019 2834',
    ),
    subtotal: 69.99,
    deliveryFee: 10.00,
    total: 79.99,
    paymentMethod: PaymentMethodType.netbanking,
    status: 'delivered',
    statusHistory: [
      OrderStatusHistory(
        status: 'pending',
        timestamp: DateTime(2026, 10, 24, 16, 20),
      ),
      OrderStatusHistory(
        status: 'processing',
        timestamp: DateTime(2026, 10, 24, 18, 0),
      ),
      OrderStatusHistory(
        status: 'shipped',
        timestamp: DateTime(2026, 10, 25, 9, 15),
      ),
      OrderStatusHistory(
        status: 'delivered',
        timestamp: DateTime(2026, 10, 26, 14, 40),
        note: 'Delivered to front porch',
      ),
    ],
    createdAt: DateTime(2026, 10, 24, 16, 20),
    updatedAt: DateTime(2026, 10, 26, 14, 40),
  ),
  OrderModel(
    id: 'ORD-20261026-0910',
    customerId: 'usr_cust_005',
    customerName: 'David Chen',
    customerEmail: 'david.chen@example.com',
    customerPhone: '+1 555 982 1100',
    items: const [
      OrderItemModel(
        productId: 'prod_001',
        title: 'Sony WH-1000XM5 Wireless Headphones',
        price: 349.99,
        quantity: 1,
        imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&q=80',
      ),
    ],
    deliveryAddress: const CustomerAddressModel(
      street: '88 Market Street',
      city: 'San Francisco',
      state: 'CA',
      postalCode: '94105',
      country: 'USA',
      recipientName: 'David Chen',
      phone: '+1 555 982 1100',
    ),
    subtotal: 349.99,
    deliveryFee: 15.00,
    total: 364.99,
    paymentMethod: PaymentMethodType.cod,
    status: 'cancelled',
    statusHistory: [
      OrderStatusHistory(
        status: 'pending',
        timestamp: DateTime(2026, 10, 26, 8, 30),
      ),
      OrderStatusHistory(
        status: 'cancelled',
        timestamp: DateTime(2026, 10, 26, 9, 10),
        note: 'Customer requested cancellation prior to shipping',
      ),
    ],
    createdAt: DateTime(2026, 10, 26, 8, 30),
    updatedAt: DateTime(2026, 10, 26, 9, 10),
  ),
];
