import '../../../catalog/domain/entities/product_entity.dart';
import '../entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<List<CartItemEntity>> getCartItems();
  Future<void> addToCart(ProductEntity product, {int quantity = 1});
  Future<void> removeFromCart(String productId);
  Future<void> updateQuantity(String productId, int quantity);
  Future<void> clearCart();
  Future<double> getTotalPrice();
  Future<int> getTotalItems();
}
