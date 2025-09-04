import '../../../cart/domain/entities/cart_item_entity.dart';

enum OrderStatus { pending, confirmed, shipped, delivered, cancelled }

class OrderEntity {
  final String id;
  final String userId;
  final List<CartItemEntity> items;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;
  final String shippingAddress;
  final String paymentMethod;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.shippingAddress,
    required this.paymentMethod,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderEntity &&
        other.id == id &&
        other.userId == userId &&
        other.items == items &&
        other.totalAmount == totalAmount &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.shippingAddress == shippingAddress &&
        other.paymentMethod == paymentMethod;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        items.hashCode ^
        totalAmount.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        shippingAddress.hashCode ^
        paymentMethod.hashCode;
  }
}
