import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Customer relationship tier categorization
enum CustomerTier {
  vip('VIP', AppColors.primary, IconsaxPlusBold.crown),
  active('Active', AppColors.success, IconsaxPlusBold.verify),
  newCustomer('New', AppColors.warning, IconsaxPlusBold.user_add),
  inactive('Inactive', AppColors.textSecondary, IconsaxPlusBold.timer);

  const CustomerTier(this.label, this.color, this.icon);

  final String label;
  final Color color;
  final IconData icon;
}

// Customer entity with purchasing metrics
class CustomerViewModel extends Equatable {
  const CustomerViewModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.joinedAt,
    this.address,
    this.avatarUrl,
    this.orders = const [],
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime joinedAt;
  final CustomerAddressModel? address;
  final String? avatarUrl;
  final List<OrderModel> orders;

  // Total count of orders placed
  int get orderCount => orders.length;

  // Total count of successful/fulfilled orders
  int get completedOrdersCount =>
      orders.where((o) => o.status != OrderStatus.cancelled.value).length;

  // Total lifetime revenue from this customer
  double get lifetimeValue => orders
      .where((o) => o.status != OrderStatus.cancelled.value)
      .fold<double>(0.0, (sum, o) => sum + o.total);

  // Average basket size per order
  double get averageOrderValue =>
      orderCount == 0 ? 0.0 : lifetimeValue / orderCount;

  // Automatically computed segment tier
  CustomerTier get tier {
    if (lifetimeValue >= 15000 || orderCount >= 3) {
      return CustomerTier.vip;
    }
    if (orderCount >= 1 && completedOrdersCount >= 1) {
      return CustomerTier.active;
    }
    final daysSinceJoined = DateTime.now().difference(joinedAt).inDays;
    if (daysSinceJoined <= 30) {
      return CustomerTier.newCustomer;
    }
    return CustomerTier.inactive;
  }

  // Initials for fallback avatar badge
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'U';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  CustomerViewModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    DateTime? joinedAt,
    CustomerAddressModel? address,
    String? avatarUrl,
    List<OrderModel>? orders,
  }) {
    return CustomerViewModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      joinedAt: joinedAt ?? this.joinedAt,
      address: address ?? this.address,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      orders: orders ?? this.orders,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    joinedAt,
    address,
    avatarUrl,
    orders,
  ];
}
