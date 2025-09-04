import 'package:flutter_ecom/features/cart/domain/entities/cart_item_entity.dart';
import 'package:flutter_ecom/features/catalog/domain/entities/product_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CartItemEntity', () {
    late ProductEntity product;

    setUp(() {
      product = const ProductEntity(
        id: '1',
        title: 'Test Product',
        description: 'Test Description',
        price: 29.99,
        thumbnail: 'https://example.com/image.jpg',
        images: ['https://example.com/image1.jpg'],
        category: 'Electronics',
        stock: 10,
      );
    });

    test('should create a cart item with product and quantity', () {
      // Arrange
      final cartItem = CartItemEntity(
        product: product,
        quantity: 2,
      );

      // Assert
      expect(cartItem.product, product);
      expect(cartItem.quantity, 2);
      expect(cartItem.totalPrice, 59.98); // 29.99 * 2
    });

    test('should calculate total price correctly', () {
      // Arrange
      final cartItem = CartItemEntity(
        product: product,
        quantity: 3,
      );

      // Assert
      expect(cartItem.totalPrice, 89.97); // 29.99 * 3
    });

    test('should support copyWith method', () {
      // Arrange
      final cartItem = CartItemEntity(
        product: product,
        quantity: 2,
      );

      // Act
      final updatedCartItem = cartItem.copyWith(quantity: 5);

      // Assert
      expect(updatedCartItem.product, product);
      expect(updatedCartItem.quantity, 5);
      expect(cartItem.quantity, 2); // Original should remain unchanged
    });

    test('should support equality comparison', () {
      // Arrange
      final cartItem1 = CartItemEntity(
        product: product,
        quantity: 2,
      );

      final cartItem2 = CartItemEntity(
        product: product,
        quantity: 2,
      );

      final cartItem3 = CartItemEntity(
        product: product,
        quantity: 3,
      );

      // Assert
      expect(cartItem1, equals(cartItem2));
      expect(cartItem1, isNot(equals(cartItem3)));
    });
  });
}
