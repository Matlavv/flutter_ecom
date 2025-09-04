import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Stream<List<ProductModel>> getProducts();
  Future<ProductModel?> getProductById(String id);
  Future<String> createProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
  Stream<List<ProductModel>> searchProducts(String query);
  Stream<List<ProductModel>> getProductsByCategory(String category);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore _firestore;
  static const String _collection = 'products';

  ProductRemoteDataSourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Stream<List<ProductModel>> getProducts() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return ProductModel.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération du produit: $e');
    }
  }

  @override
  Future<String> createProduct(ProductModel product) async {
    try {
      final docRef = await _firestore.collection(_collection).add({
        ...product.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Erreur lors de la création du produit: $e');
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    try {
      await _firestore.collection(_collection).doc(product.id).update({
        ...product.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du produit: $e');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression du produit: $e');
    }
  }

  @override
  Stream<List<ProductModel>> searchProducts(String query) {
    return _firestore
        .collection(_collection)
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThan: query + 'z')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  @override
  Stream<List<ProductModel>> getProductsByCategory(String category) {
    // Si la catégorie est "Toutes", retourner tous les produits
    if (category == 'Toutes') {
      return getProducts();
    }

    return _firestore
        .collection(_collection)
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }
}
