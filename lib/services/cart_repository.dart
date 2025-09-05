import '../models/cart_item_entity.dart';
import '../models/product_entity.dart';

abstract class CartRepository {
  Future<List<CartItemEntity>> getCartItems();
  Future<void> addToCart(ProductEntity product, {int quantity = 1});
  Future<void> removeFromCart(String productId);
  Future<void> updateQuantity(String productId, int quantity);
  Future<void> clearCart();
  Future<double> getTotalPrice();
  Future<int> getTotalItems();
}
