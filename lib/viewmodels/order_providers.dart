import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/order_remote_datasource.dart';
import '../services/order_repository_impl.dart';
import '../models/order_entity.dart';
import '../services/order_repository.dart';
import '../viewmodels/create_order_usecase.dart';

// Data Sources
final orderRemoteDataSourceProvider = Provider<OrderRemoteDataSource>((ref) {
  return OrderRemoteDataSourceImpl(
    firestore: FirebaseFirestore.instance,
  );
});

// Repositories
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(
    remoteDataSource: ref.watch(orderRemoteDataSourceProvider),
  );
});

// Use Cases
final createOrderUseCaseProvider = Provider<CreateOrderUseCase>((ref) {
  return CreateOrderUseCase(ref.watch(orderRepositoryProvider));
});

// State Providers
final userOrdersProvider =
    StreamProvider.family<List<OrderEntity>, String>((ref, userId) {
  return ref.watch(orderRepositoryProvider).getUserOrders(userId);
});
