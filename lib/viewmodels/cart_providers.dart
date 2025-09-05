import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/cart_local_datasource.dart';
import '../services/cart_repository_impl.dart';
import '../models/cart_item_entity.dart';
import '../services/cart_repository.dart';
import '../viewmodels/add_to_cart_usecase.dart';

// Data Sources
final cartLocalDataSourceProvider = Provider<CartLocalDataSource>((ref) {
  return CartLocalDataSourceImpl();
});

// Repositories
final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl(
    localDataSource: ref.watch(cartLocalDataSourceProvider),
  );
});

// Use Cases
final addToCartUseCaseProvider = Provider<AddToCartUseCase>((ref) {
  return AddToCartUseCase(ref.watch(cartRepositoryProvider));
});

// State Providers
final cartItemsProvider = FutureProvider<List<CartItemEntity>>((ref) {
  return ref.watch(cartRepositoryProvider).getCartItems();
});

final cartTotalProvider = FutureProvider<double>((ref) {
  return ref.watch(cartRepositoryProvider).getTotalPrice();
});

final cartItemsCountProvider = FutureProvider<int>((ref) {
  return ref.watch(cartRepositoryProvider).getTotalItems();
});
