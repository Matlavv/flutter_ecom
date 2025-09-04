import 'package:flutter/material.dart';
import 'package:flutter_ecom/features/catalog/domain/entities/product_entity.dart';
import 'package:flutter_ecom/shared/widgets/product_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProductCard', () {
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

    testWidgets('should display product information correctly',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: product),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('29,99 €'), findsOneWidget);
      expect(find.text('Electronics'), findsOneWidget);
      expect(find.text('En stock'), findsOneWidget);
    });

    testWidgets('should display out of stock when stock is 0',
        (WidgetTester tester) async {
      // Arrange
      final outOfStockProduct = product.copyWith(stock: 0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: outOfStockProduct),
          ),
        ),
      );

      // Assert
      expect(find.text('Rupture de stock'), findsOneWidget);
    });

    testWidgets('should display low stock when stock is less than 5',
        (WidgetTester tester) async {
      // Arrange
      final lowStockProduct = product.copyWith(stock: 3);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: lowStockProduct),
          ),
        ),
      );

      // Assert
      expect(find.text('Stock faible'), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (WidgetTester tester) async {
      // Arrange
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(
              product: product,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(ProductCard));
      await tester.pump();

      // Assert
      expect(tapped, true);
    });
  });
}
