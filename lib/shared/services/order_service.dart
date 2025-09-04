import 'package:cloud_firestore/cloud_firestore.dart' hide Order;

import '../models/cart_item.dart';
import '../models/order.dart';

class OrderService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'orders';

  // Créer une nouvelle commande
  static Future<String> createOrder({
    required String userId,
    required List<CartItem> items,
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    try {
      final totalAmount =
          items.fold(0.0, (total, item) => total + item.totalPrice);

      final order = Order(
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

  // Récupérer les commandes d'un utilisateur
  static Stream<List<Order>> getUserOrders(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map<List<Order>>(
          (snapshot) => snapshot.docs
              .map((doc) => Order.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  // Récupérer une commande par ID
  static Future<Order?> getOrderById(String orderId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(orderId).get();
      if (doc.exists) {
        return Order.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération de la commande: $e');
    }
  }

  // Mettre à jour le statut d'une commande
  static Future<void> updateOrderStatus(
    String orderId,
    OrderStatus status,
  ) async {
    try {
      await _firestore.collection(_collection).doc(orderId).update({
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de la commande: $e');
    }
  }

  // Simuler un paiement (pour le MVP)
  static Future<bool> simulatePayment({
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
