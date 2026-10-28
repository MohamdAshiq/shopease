import 'package:equatable/equatable.dart';

import '../constants/order_status.dart';
import 'customer_address_model.dart';
import 'order_item_model.dart';

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
    customerPhone: '+1 555-0199',
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
      phone: '+1 555-0199',
    ),
    subtotal: 478.99,
    deliveryFee: 15.00,
    total: 493.99,
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
    customerPhone: '+1 555-0199',
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
      phone: '+1 555-0199',
    ),
    subtotal: 149.99,
    deliveryFee: 10.00,
    total: 159.99,
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
];
