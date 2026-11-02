import '../models/order_model.dart';

abstract class OrderRepository {
  // Places a new customer order and returns the stored entity
  Future<OrderModel> createOrder(OrderModel order);

  // Streams real-time orders for a specific customer
  Stream<List<OrderModel>> watchCustomerOrders(String customerId);

  // Streams all orders for admin
  Stream<List<OrderModel>> watchAllOrders();

  // Retrieves a specific order by ID
  Future<OrderModel?> getOrderById(String orderId);

  // Updates status with timeline history note
  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
    String? note,
  });

  // Cancels a customer order
  Future<void> cancelOrder({required String orderId, String? reason});
}
