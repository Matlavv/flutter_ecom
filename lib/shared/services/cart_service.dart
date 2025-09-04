import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartService {
  static const String _cartKey = 'cart_items';

  // Récupérer le panier depuis le stockage local
  static Future<List<CartItem>> getCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartKey);

      if (cartJson == null) return [];

      final List<dynamic> cartList = json.decode(cartJson);
      return cartList.map((item) => CartItem.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  // Sauvegarder le panier dans le stockage local
  static Future<void> _saveCartItems(List<CartItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(items.map((item) => item.toJson()).toList());
      await prefs.setString(_cartKey, cartJson);
    } catch (e) {
      throw Exception('Erreur lors de la sauvegarde du panier: $e');
    }
  }

  // Ajouter un produit au panier
  static Future<void> addToCart(Product product, {int quantity = 1}) async {
    final cartItems = await getCartItems();

    // Vérifier si le produit existe déjà dans le panier
    final existingIndex = cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex != -1) {
      // Augmenter la quantité
      cartItems[existingIndex] = cartItems[existingIndex].copyWith(
        quantity: cartItems[existingIndex].quantity + quantity,
      );
    } else {
      // Ajouter un nouvel item
      cartItems.add(CartItem(product: product, quantity: quantity));
    }

    await _saveCartItems(cartItems);
  }

  // Supprimer un produit du panier
  static Future<void> removeFromCart(String productId) async {
    final cartItems = await getCartItems();
    cartItems.removeWhere((item) => item.product.id == productId);
    await _saveCartItems(cartItems);
  }

  // Mettre à jour la quantité d'un produit
  static Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }

    final cartItems = await getCartItems();
    final index = cartItems.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      cartItems[index] = cartItems[index].copyWith(quantity: quantity);
      await _saveCartItems(cartItems);
    }
  }

  // Vider le panier
  static Future<void> clearCart() async {
    await _saveCartItems([]);
  }

  // Calculer le total du panier
  static Future<double> getTotalPrice() async {
    final cartItems = await getCartItems();
    return cartItems.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Obtenir le nombre total d'articles
  static Future<int> getTotalItems() async {
    final cartItems = await getCartItems();
    return cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
  }
}
