import 'package:flutter_ecom/features/catalog/domain/entities/product_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProductEntity', () {
    test('should create a product entity with all properties', () {
      // Arrange
      const product = ProductEntity(
        id: '1',
        title: 'Test Product',
        description: 'Test Description',
        price: 29.99,
        thumbnail: 'https://example.com/image.jpg',
        images: [
          'https://example.com/image1.jpg',
          'https://example.com/image2.jpg'
        ],
        category: 'Electronics',
        stock: 10,
      );

      // Assert
      expect(product.id, '1');
      expect(product.title, 'Test Product');
      expect(product.description, 'Test Description');
      expect(product.price, 29.99);
      expect(product.thumbnail, 'https://example.com/image.jpg');
      expect(product.images,
          ['https://example.com/image1.jpg', 'https://example.com/image2.jpg']);
      expect(product.category, 'Electronics');
      expect(product.stock, 10);
    });

    test('should support equality comparison', () {
      // Arrange
      const product1 = ProductEntity(
        id: '1',
        title: 'Test Product',
        description: 'Test Description',
        price: 29.99,
        thumbnail: 'https://example.com/image.jpg',
        images: ['https://example.com/image1.jpg'],
        category: 'Electronics',
        stock: 10,
      );

      const product2 = ProductEntity(
        id: '1',
        title: 'Test Product',
        description: 'Test Description',
        price: 29.99,
        thumbnail: 'https://example.com/image.jpg',
        images: ['https://example.com/image1.jpg'],
        category: 'Electronics',
        stock: 10,
      );

      const product3 = ProductEntity(
        id: '2',
        title: 'Different Product',
        description: 'Test Description',
        price: 29.99,
        thumbnail: 'https://example.com/image.jpg',
        images: ['https://example.com/image1.jpg'],
        category: 'Electronics',
        stock: 10,
      );

      // Assert
      expect(product1, equals(product2));
      expect(product1, isNot(equals(product3)));
    });
  });
}
