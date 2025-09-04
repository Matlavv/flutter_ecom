import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../cart/data/models/cart_item_model.dart';
import '../../domain/entities/order_entity.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<String> createOrder({
    required String userId,
    required List<CartItemModel> items,
    required String shippingAddress,
    required String paymentMethod,
  });
  Stream<List<OrderModel>> getUserOrders(String userId);
  Future<OrderModel?> getOrderById(String orderId);
  Future<void> updateOrderStatus(String orderId, String status);
  Future<bool> simulatePayment({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required double amount,
  });
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final FirebaseFirestore _firestore;
  static const String _collection = 'orders';

  OrderRemoteDataSourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<String> createOrder({
    required String userId,
    required List<CartItemModel> items,
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    try {
      final totalAmount =
          items.fold(0.0, (total, item) => total + item.totalPrice);

      final order = OrderModel(
        id: '', // Sera généré par Firestore
        userId: userId,
        items: items,
        totalAmount: totalAmount,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
        shippingAddress: shippingAddress,
        paymentMethod: paymentMethod,
      );

      final docRef = await _firestore.collection(_collection).add({
        ...order.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return docRef.id;
    } catch (e) {
      throw Exception('Erreur lors de la création de la commande: $e');
    }
  }

  @override
  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  @override
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(orderId).get();
      if (doc.exists) {
        return OrderModel.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération de la commande: $e');
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection(_collection).doc(orderId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de la commande: $e');
    }
  }

  @override
  Future<bool> simulatePayment({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required double amount,
  }) async {
    // Simulation d'un délai de traitement
    await Future.delayed(const Duration(seconds: 2));

    // Simulation : 90% de succès
    return DateTime.now().millisecond % 10 != 0;
  }
}
