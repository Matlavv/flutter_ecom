import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> saveCartItems(List<CartItemModel> items);
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String _cartKey = 'cart_items';

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartKey);

      if (cartJson == null) return [];

      final List<dynamic> cartList = json.decode(cartJson);
      return cartList.map((item) => CartItemModel.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveCartItems(List<CartItemModel> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(items.map((item) => item.toJson()).toList());
      await prefs.setString(_cartKey, cartJson);
    } catch (e) {
      throw Exception('Erreur lors de la sauvegarde du panier: $e');
    }
  }
}
