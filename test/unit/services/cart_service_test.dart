import 'package:flutter_ecom/shared/models/product.dart';
import 'package:flutter_ecom/shared/services/cart_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('CartService Tests', () {
    late Product testProduct;

    setUp(() {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
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

    test('should add product to cart', () async {
      // Act
      await CartService.addToCart(testProduct, quantity: 2);

      // Assert
      final cartItems = await CartService.getCartItems();
      expect(cartItems, hasLength(1));
      expect(cartItems.first.product.id, '1');
      expect(cartItems.first.quantity, 2);
    });

    test('should update quantity when adding existing product', () async {
      // Arrange
      await CartService.addToCart(testProduct, quantity: 2);

      // Act
      await CartService.addToCart(testProduct, quantity: 3);

      // Assert
      final cartItems = await CartService.getCartItems();
      expect(cartItems, hasLength(1));
      expect(cartItems.first.quantity, 5); // 2 + 3
    });

    test('should remove product from cart', () async {
      // Arrange
      await CartService.addToCart(testProduct);

      // Act
      await CartService.removeFromCart('1');

      // Assert
      final cartItems = await CartService.getCartItems();
      expect(cartItems, isEmpty);
    });

    test('should calculate total price correctly', () async {
      // Arrange
      final product2 = Product(
        id: '2',
        title: 'Test Product 2',
        price: 19.99,
        description: 'Another test product',
        category: 'Test',
        thumbnail: 'https://example.com/image2.jpg',
        images: ['https://example.com/image2.jpg'],
        stock: 5,
      );

      await CartService.addToCart(
        testProduct,
        quantity: 2,
      ); // 29.99 * 2 = 59.98
      await CartService.addToCart(product2, quantity: 1); // 19.99 * 1 = 19.99

      // Act
      final totalPrice = await CartService.getTotalPrice();

      // Assert
      expect(totalPrice, 79.97); // 59.98 + 19.99
    });

    test('should calculate total items correctly', () async {
      // Arrange
      await CartService.addToCart(testProduct, quantity: 3);
      await CartService.addToCart(
        testProduct,
        quantity: 2,
      ); // Same product, should add to existing

      // Act
      final totalItems = await CartService.getTotalItems();

      // Assert
      expect(totalItems, 5); // 3 + 2
    });

    test('should clear cart', () async {
      // Arrange
      await CartService.addToCart(testProduct);

      // Act
      await CartService.clearCart();

      // Assert
      final cartItems = await CartService.getCartItems();
      expect(cartItems, isEmpty);
    });
  });
}
