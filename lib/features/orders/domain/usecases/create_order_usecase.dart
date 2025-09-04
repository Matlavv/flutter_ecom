import '../../../cart/domain/entities/cart_item_entity.dart';
import '../repositories/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository _repository;

  CreateOrderUseCase(this._repository);

  Future<String> call({
    required String userId,
    required List<CartItemEntity> items,
    required String shippingAddress,
    required String paymentMethod,
  }) {
    return _repository.createOrder(
      userId: userId,
      items: items,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
    );
  }
}
