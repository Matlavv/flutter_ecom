import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';

class ProductService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'products';

  // Récupérer tous les produits
  static Stream<List<Product>> getProducts() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Product.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  // Récupérer un produit par ID
  static Future<Product?> getProductById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return Product.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération du produit: $e');
    }
  }

  // Créer un nouveau produit
  static Future<String> createProduct(Product product) async {
    try {
      final docRef = await _firestore.collection(_collection).add({
        ...product.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Erreur lors de la création du produit: $e');
    }
  }

  // Mettre à jour un produit
  static Future<void> updateProduct(String id, Product product) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        ...product.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du produit: $e');
    }
  }

  // Supprimer un produit
  static Future<void> deleteProduct(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression du produit: $e');
    }
  }

  // Rechercher des produits
  static Stream<List<Product>> searchProducts(String query) {
    if (query.isEmpty) return getProducts();

    return _firestore
        .collection(_collection)
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: '$query\uf8ff')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Product.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  // Filtrer par catégorie
  static Stream<List<Product>> getProductsByCategory(String category) {
    if (category == 'Toutes') return getProducts();

    return _firestore
        .collection(_collection)
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Product.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }
}
