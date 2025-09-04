import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import '../services/order_service.dart';
import '../services/product_service.dart';

// Provider pour AuthService
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Provider pour l'état d'authentification
final authStateProvider = StreamProvider<User?>((ref) {
  return AuthService.authStateChanges;
});

// Provider pour l'utilisateur actuel
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Provider pour vérifier si l'utilisateur est connecté
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

// Provider pour tous les produits
final productsProvider = StreamProvider<List<Product>>((ref) {
  return ProductService.getProducts();
});

// Provider pour un produit spécifique
final productProvider = FutureProvider.family<Product?, String>((
  ref,
  productId,
) {
  return ProductService.getProductById(productId);
});

// Provider pour la recherche de produits
final searchProductsProvider = StreamProvider.family<List<Product>, String>((
  ref,
  query,
) {
  return ProductService.searchProducts(query);
});

// Provider pour les produits par catégorie
final productsByCategoryProvider = StreamProvider.family<List<Product>, String>(
  (ref, category) {
    return ProductService.getProductsByCategory(category);
  },
);

// Provider pour le panier
final cartItemsProvider = FutureProvider<List<CartItem>>((ref) {
  return CartService.getCartItems();
});

// Provider pour le total du panier
final cartTotalProvider = FutureProvider<double>((ref) {
  return CartService.getTotalPrice();
});

// Provider pour le nombre d'articles dans le panier
final cartItemsCountProvider = FutureProvider<int>((ref) {
  return CartService.getTotalItems();
});

// Provider pour les commandes d'un utilisateur
final userOrdersProvider = StreamProvider.family<List<Order>, String>((
  ref,
  userId,
) {
  return OrderService.getUserOrders(userId);
});
