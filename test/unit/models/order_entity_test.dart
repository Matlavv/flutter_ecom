import 'package:flutter_ecom/features/cart/domain/entities/cart_item_entity.dart';
import 'package:flutter_ecom/features/catalog/domain/entities/product_entity.dart';
import 'package:flutter_ecom/features/orders/domain/entities/order_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OrderEntity', () {
    late ProductEntity product;
    late CartItemEntity cartItem;

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

      cartItem = CartItemEntity(
        product: product,
        quantity: 2,
      );
    });

    test('should create an order entity with all properties', () {
      // Arrange
      final now = DateTime.now();
      final order = OrderEntity(
        id: '1',
        userId: 'user1',
        items: [cartItem],
        totalAmount: 59.98,
        status: OrderStatus.pending,
        createdAt: now,
        shippingAddress: '123 Test St',
        paymentMethod: 'Credit Card',
      );

      // Assert
      expect(order.id, '1');
      expect(order.userId, 'user1');
      expect(order.items, [cartItem]);
      expect(order.totalAmount, 59.98);
      expect(order.status, OrderStatus.pending);
      expect(order.createdAt, now);
      expect(order.shippingAddress, '123 Test St');
      expect(order.paymentMethod, 'Credit Card');
    });

    test('should support all order statuses', () {
      // Arrange
      final now = DateTime.now();
      final order = OrderEntity(
        id: '1',
        userId: 'user1',
        items: [cartItem],
        totalAmount: 59.98,
        status: OrderStatus.confirmed,
        createdAt: now,
        shippingAddress: '123 Test St',
        paymentMethod: 'Credit Card',
      );

      // Assert
      expect(order.status, OrderStatus.confirmed);
      expect(OrderStatus.values, contains(OrderStatus.pending));
      expect(OrderStatus.values, contains(OrderStatus.confirmed));
      expect(OrderStatus.values, contains(OrderStatus.shipped));
      expect(OrderStatus.values, contains(OrderStatus.delivered));
      expect(OrderStatus.values, contains(OrderStatus.cancelled));
    });

    test('should support equality comparison', () {
      // Arrange
      final now = DateTime.now();
      final order1 = OrderEntity(
        id: '1',
        userId: 'user1',
        items: [cartItem],
        totalAmount: 59.98,
        status: OrderStatus.pending,
        createdAt: now,
        shippingAddress: '123 Test St',
        paymentMethod: 'Credit Card',
      );

      final order2 = OrderEntity(
        id: '1',
        userId: 'user1',
        items: [cartItem],
        totalAmount: 59.98,
        status: OrderStatus.pending,
        createdAt: now,
        shippingAddress: '123 Test St',
        paymentMethod: 'Credit Card',
      );

      final order3 = OrderEntity(
        id: '2',
        userId: 'user1',
        items: [cartItem],
        totalAmount: 59.98,
        status: OrderStatus.pending,
        createdAt: now,
        shippingAddress: '123 Test St',
        paymentMethod: 'Credit Card',
      );

      // Assert
      expect(order1, equals(order2));
      expect(order1, isNot(equals(order3)));
    });
  });
}
