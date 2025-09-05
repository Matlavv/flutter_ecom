import '../models/product_entity.dart';
import '../services/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository _repository;

  AddToCartUseCase(this._repository);

  Future<void> call(ProductEntity product, {int quantity = 1}) {
    return _repository.addToCart(product, quantity: quantity);
  }
}
