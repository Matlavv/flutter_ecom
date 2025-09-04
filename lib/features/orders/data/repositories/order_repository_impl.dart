import '../../../cart/data/models/cart_item_model.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _remoteDataSource;

  OrderRepositoryImpl({required OrderRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<String> createOrder({
    required String userId,
    required List<CartItemEntity> items,
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    final models = items.map((item) => CartItemModel.fromEntity(item)).toList();
    return _remoteDataSource.createOrder(
      userId: userId,
      items: models,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
    );
  }

  @override
  Stream<List<OrderEntity>> getUserOrders(String userId) {
    return _remoteDataSource.getUserOrders(userId).map(
          (orders) => orders.map((order) => order.toEntity()).toList(),
        );
  }

  @override
  Future<OrderEntity?> getOrderById(String orderId) async {
    final order = await _remoteDataSource.getOrderById(orderId);
    return order?.toEntity();
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) {
    return _remoteDataSource.updateOrderStatus(orderId, status.name);
  }

  @override
  Future<bool> simulatePayment({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required double amount,
  }) {
    return _remoteDataSource.simulatePayment(
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cvv: cvv,
      amount: amount,
    );
  }
}
