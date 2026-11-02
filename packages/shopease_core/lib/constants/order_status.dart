import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

// Order fulfillment statuses
enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled;

  String get value => name;

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  // Title for order tracking stepper
  String get timelineTitle {
    switch (this) {
      case OrderStatus.pending:
        return 'Order Placed';
      case OrderStatus.processing:
        return 'Processing & Packed';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Order Cancelled';
    }
  }

  // Next fulfillment status in the lifecycle
  OrderStatus? get nextStatus {
    switch (this) {
      case OrderStatus.pending:
        return OrderStatus.processing;
      case OrderStatus.processing:
        return OrderStatus.shipped;
      case OrderStatus.shipped:
        return OrderStatus.delivered;
      case OrderStatus.delivered:
      case OrderStatus.cancelled:
        return null;
    }
  }

  // Status Colors
  Color get statusColor {
    switch (this) {
      case OrderStatus.pending:
        return AppColors.warning;
      case OrderStatus.processing:
      case OrderStatus.shipped:
        return AppColors.primary;
      case OrderStatus.delivered:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
    }
  }

  // Progress index for customer tracking stepper
  int get stepIndex {
    switch (this) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.processing:
        return 1;
      case OrderStatus.shipped:
        return 2;
      case OrderStatus.delivered:
        return 3;
      case OrderStatus.cancelled:
        return -1;
    }
  }

  static OrderStatus fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'pending':
      default:
        return OrderStatus.pending;
    }
  }
}
