import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/order_status.dart';
import '../models/order_model.dart';
import 'order_repository.dart';

// Cloud Firestore implementation of OrderRepository
class FirestoreOrderRepository implements OrderRepository {
  FirestoreOrderRepository({FirebaseFirestore? firestore})
    : _customFirestore = firestore;

  final FirebaseFirestore? _customFirestore;
  FirebaseFirestore get _firestore =>
      _customFirestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _ordersRef =>
      _firestore.collection('orders');

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    final docRef = _ordersRef.doc(order.id.isNotEmpty ? order.id : null);
    final orderId = docRef.id;

    final updatedOrder = order.copyWith(id: orderId);
    final data = updatedOrder.toMap()
      ..['id'] = orderId
      ..['createdAt'] = FieldValue.serverTimestamp()
      ..['updatedAt'] = FieldValue.serverTimestamp();

    await docRef.set(data);
    return updatedOrder;
  }

  @override
  Stream<List<OrderModel>> watchCustomerOrders(String customerId) {
    if (customerId.isEmpty) {
      return Stream.value(const []);
    }

    return _ordersRef
        .where('customerId', isEqualTo: customerId)
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs.map((doc) {
            return OrderModel.fromMap(doc.data(), documentId: doc.id);
          }).toList();

          // Sort descending by creation date (newest first)
          orders.sort((a, b) {
            final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return bTime.compareTo(aTime);
          });

          return orders;
        });
  }

  @override
  Stream<List<OrderModel>> watchAllOrders() {
    return _ordersRef.snapshots().map((snapshot) {
      final orders = snapshot.docs.map((doc) {
        return OrderModel.fromMap(doc.data(), documentId: doc.id);
      }).toList();

      orders.sort((a, b) {
        final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });

      return orders;
    });
  }

  @override
  Future<OrderModel?> getOrderById(String orderId) async {
    final doc = await _ordersRef.doc(orderId).get();
    if (!doc.exists || doc.data() == null) return null;
    return OrderModel.fromMap(doc.data()!, documentId: doc.id);
  }

  @override
  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
    String? note,
  }) async {
    final docRef = _ordersRef.doc(orderId);
    final now = DateTime.now();
    final historyEntry = OrderStatusHistory(
      status: status,
      timestamp: now,
      note: note,
    ).toMap();

    await docRef.update({
      'status': status,
      'statusHistory': FieldValue.arrayUnion([historyEntry]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> cancelOrder({required String orderId, String? reason}) async {
    await updateOrderStatus(
      orderId: orderId,
      status: OrderStatus.cancelled.value,
      note: reason ?? 'Order cancelled by customer',
    );
  }
}
