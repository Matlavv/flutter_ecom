import 'package:flutter_ecom/shared/models/cart_item.dart';
import 'package:flutter_ecom/shared/models/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CartItem Model Tests', () {
    late Product testProduct;

    setUp(() {
      testProduct = Product(
        id: '1',
        title: 'Test Product',
        price: 29.99,
        description: 'A test product',
        category: 'Test',
        thumbnail: 'https://example.com/image.jpg',
        images: ['https://example.com/image1.jpg'],
        stock: 10,
      );
    });

    test('should create a cart item from JSON', () {
      // Arrange
      final json = {'product': testProduct.toJson(), 'quantity': 2};

      // Act
      final cartItem = CartItem.fromJson(json);

      // Assert
      expect(cartItem.product.id, '1');
      expect(cartItem.product.title, 'Test Product');
      expect(cartItem.quantity, 2);
    });

    test('should convert cart item to JSON', () {
      // Arrange
      final cartItem = CartItem(product: testProduct, quantity: 3);

      // Act
      final json = cartItem.toJson();

      // Assert
      expect(json['quantity'], 3);
      expect(json['product']['id'], '1');
      expect(json['product']['title'], 'Test Product');
    });

    test('should calculate total price correctly', () {
      // Arrange
      final cartItem = CartItem(product: testProduct, quantity: 3);

      // Act
      final totalPrice = cartItem.totalPrice;

      // Assert
      expect(totalPrice, 29.99 * 3); // 89.97
    });

    test('should create cart item copy with updated quantity', () {
      // Arrange
      final originalCartItem = CartItem(product: testProduct, quantity: 2);

      // Act
      final updatedCartItem = originalCartItem.copyWith(quantity: 5);

      // Assert
      expect(updatedCartItem.product.id, '1'); // Unchanged
      expect(updatedCartItem.quantity, 5);
      expect(updatedCartItem.totalPrice, 29.99 * 5);
    });
  });
}
