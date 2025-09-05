import '../models/cart_item_entity.dart';
import '../models/order_entity.dart';

abstract class OrderRepository {
  Future<String> createOrder({
    required String userId,
    required List<CartItemEntity> items,
    required String shippingAddress,
    required String paymentMethod,
  });
  Stream<List<OrderEntity>> getUserOrders(String userId);
  Future<OrderEntity?> getOrderById(String orderId);
  Future<void> updateOrderStatus(String orderId, OrderStatus status);
  Future<bool> simulatePayment({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required double amount,
  });
}
