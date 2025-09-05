import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart_item_model.dart';
import 'order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.userId,
    required super.items,
    required super.totalAmount,
    required super.status,
    required super.createdAt,
    required super.shippingAddress,
    required super.paymentMethod,
  });

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      userId: entity.userId,
      items:
          entity.items.map((item) => CartItemModel.fromEntity(item)).toList(),
      totalAmount: entity.totalAmount,
      status: entity.status,
      createdAt: entity.createdAt,
      shippingAddress: entity.shippingAddress,
      paymentMethod: entity.paymentMethod,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List)
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      createdAt: _parseDateTime(json['createdAt']),
      shippingAddress: json['shippingAddress'] as String,
      paymentMethod: json['paymentMethod'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => (item as CartItemModel).toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status.name,
      'createdAt': createdAt,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
    };
  }

  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue is Timestamp) return dateValue.toDate();
    if (dateValue is String) return DateTime.parse(dateValue);
    if (dateValue is DateTime) return dateValue;
    return DateTime.now();
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      userId: userId,
      items: items.map((item) => (item as CartItemModel).toEntity()).toList(),
      totalAmount: totalAmount,
      status: status,
      createdAt: createdAt,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
    );
  }
}
