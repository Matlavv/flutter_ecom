import 'package:flutter_ecom/shared/models/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Product Model Tests', () {
    test('should create a product from JSON', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Test Product',
        'price': 29.99,
        'description': 'A test product',
        'category': 'Test',
        'thumbnail': 'https://example.com/image.jpg',
        'images': [
          'https://example.com/image1.jpg',
          'https://example.com/image2.jpg',
        ],
        'stock': 10,
      };

      // Act
      final product = Product.fromJson(json);

      // Assert
      expect(product.id, '1');
      expect(product.title, 'Test Product');
      expect(product.price, 29.99);
      expect(product.description, 'A test product');
      expect(product.category, 'Test');
      expect(product.thumbnail, 'https://example.com/image.jpg');
      expect(product.images, hasLength(2));
      expect(product.stock, 10);
    });

    test('should convert product to JSON', () {
      // Arrange
      final product = Product(
        id: '1',
        title: 'Test Product',
        price: 29.99,
        description: 'A test product',
        category: 'Test',
        thumbnail: 'https://example.com/image.jpg',
        images: ['https://example.com/image1.jpg'],
        stock: 10,
      );

      // Act
      final json = product.toJson();

      // Assert
      expect(json['id'], '1');
      expect(json['title'], 'Test Product');
      expect(json['price'], 29.99);
      expect(json['description'], 'A test product');
      expect(json['category'], 'Test');
      expect(json['thumbnail'], 'https://example.com/image.jpg');
      expect(json['images'], hasLength(1));
      expect(json['stock'], 10);
    });

    test('should create product copy with updated values', () {
      // Arrange
      final originalProduct = Product(
        id: '1',
        title: 'Original Product',
        price: 29.99,
        description: 'Original description',
        category: 'Original',
        thumbnail: 'https://example.com/original.jpg',
        images: ['https://example.com/original1.jpg'],
        stock: 10,
      );

      // Act
      final updatedProduct = originalProduct.copyWith(
        title: 'Updated Product',
        price: 39.99,
        stock: 5,
      );

      // Assert
      expect(updatedProduct.id, '1'); // Unchanged
      expect(updatedProduct.title, 'Updated Product');
      expect(updatedProduct.price, 39.99);
      expect(updatedProduct.description, 'Original description'); // Unchanged
      expect(updatedProduct.category, 'Original'); // Unchanged
      expect(updatedProduct.stock, 5);
    });
  });
}
