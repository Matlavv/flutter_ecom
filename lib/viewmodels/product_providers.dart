import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/product_remote_datasource.dart';
import '../services/product_repository_impl.dart';
import '../models/product_entity.dart';
import '../services/product_repository.dart';
import '../viewmodels/create_product_usecase.dart';
import '../viewmodels/get_products_usecase.dart';

// Data Sources
final productRemoteDataSourceProvider =
    Provider<ProductRemoteDataSource>((ref) {
  return ProductRemoteDataSourceImpl(
    firestore: FirebaseFirestore.instance,
  );
});

// Repositories
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(
    remoteDataSource: ref.watch(productRemoteDataSourceProvider),
  );
});

// Use Cases
final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  return GetProductsUseCase(ref.watch(productRepositoryProvider));
});

final createProductUseCaseProvider = Provider<CreateProductUseCase>((ref) {
  return CreateProductUseCase(ref.watch(productRepositoryProvider));
});

// State Providers
final productsProvider = StreamProvider<List<ProductEntity>>((ref) {
  return ref.watch(getProductsUseCaseProvider)();
});

final productProvider =
    FutureProvider.family<ProductEntity?, String>((ref, productId) {
  return ref.watch(productRepositoryProvider).getProductById(productId);
});

final searchProductsProvider =
    StreamProvider.family<List<ProductEntity>, String>((ref, query) {
  return ref.watch(productRepositoryProvider).searchProducts(query);
});

final productsByCategoryProvider =
    StreamProvider.family<List<ProductEntity>, String>((ref, category) {
  return ref.watch(productRepositoryProvider).getProductsByCategory(category);
});
