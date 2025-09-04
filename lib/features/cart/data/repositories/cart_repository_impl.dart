import '../../../catalog/domain/entities/product_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_datasource.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource _localDataSource;

  CartRepositoryImpl({required CartLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<List<CartItemEntity>> getCartItems() async {
    final items = await _localDataSource.getCartItems();
    return items.map((item) => item.toEntity()).toList();
  }

  @override
  Future<void> addToCart(ProductEntity product, {int quantity = 1}) async {
    final cartItems = await getCartItems();

    // Vérifier si le produit existe déjà dans le panier
    final existingIndex = cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex != -1) {
      // Augmenter la quantité
      cartItems[existingIndex] = cartItems[existingIndex].copyWith(
        quantity: cartItems[existingIndex].quantity + quantity,
      );
    } else {
      // Ajouter un nouvel item
      cartItems.add(CartItemEntity(product: product, quantity: quantity));
    }

    await _saveCartItems(cartItems);
  }

  @override
  Future<void> removeFromCart(String productId) async {
    final cartItems = await getCartItems();
    cartItems.removeWhere((item) => item.product.id == productId);
    await _saveCartItems(cartItems);
  }

  @override
  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }

    final cartItems = await getCartItems();
    final index = cartItems.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      cartItems[index] = cartItems[index].copyWith(quantity: quantity);
      await _saveCartItems(cartItems);
    }
  }

  @override
  Future<void> clearCart() async {
    await _saveCartItems([]);
  }

  @override
  Future<double> getTotalPrice() async {
    final cartItems = await getCartItems();
    return cartItems.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
  }

  @override
  Future<int> getTotalItems() async {
    final cartItems = await getCartItems();
    return cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  Future<void> _saveCartItems(List<CartItemEntity> items) async {
    final models = items.map((item) => CartItemModel.fromEntity(item)).toList();
    await _localDataSource.saveCartItems(models);
  }
}
