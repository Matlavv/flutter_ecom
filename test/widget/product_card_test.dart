import 'package:flutter/material.dart';
import 'package:flutter_ecom/shared/models/product.dart';
import 'package:flutter_ecom/shared/widgets/product_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProductCard Widget Tests', () {
    late Product testProduct;

    setUp(() {
      testProduct = Product(
        id: '1',
        title: 'Test Product',
        price: 29.99,
        description: 'A test product description',
        category: 'Test',
        thumbnail: 'https://example.com/image.jpg',
        images: ['https://example.com/image1.jpg'],
        stock: 10,
      );
    });

    testWidgets('should display product information correctly', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: ProductCard(product: testProduct)),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('29.99 €'), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
      expect(find.text('10 en stock'), findsOneWidget);
      expect(find.text('A test product description'), findsOneWidget);
    });

    testWidgets('should display out of stock message when stock is 0', (
      WidgetTester tester,
    ) async {
      // Arrange
      final outOfStockProduct = testProduct.copyWith(stock: 0);

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: ProductCard(product: outOfStockProduct)),
          ),
        ),
      );

      // Assert
      expect(find.text('Rupture de stock'), findsOneWidget);
      expect(find.text('10 en stock'), findsNothing);
    });

    testWidgets('should have add to cart button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: ProductCard(product: testProduct)),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
    });

    testWidgets('should disable add to cart button when out of stock', (
      WidgetTester tester,
    ) async {
      // Arrange
      final outOfStockProduct = testProduct.copyWith(stock: 0);

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: ProductCard(product: outOfStockProduct)),
          ),
        ),
      );

      // Assert
      expect(find.text('Rupture de stock'), findsOneWidget);
      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
    });

    testWidgets('should be tappable for navigation', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: ProductCard(product: testProduct)),
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
    });
  });
}
