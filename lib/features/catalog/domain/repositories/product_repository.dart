import '../entities/product_entity.dart';

abstract class ProductRepository {
  Stream<List<ProductEntity>> getProducts();
  Future<ProductEntity?> getProductById(String id);
  Future<String> createProduct(ProductEntity product);
  Future<void> updateProduct(ProductEntity product);
  Future<void> deleteProduct(String id);
  Stream<List<ProductEntity>> searchProducts(String query);
  Stream<List<ProductEntity>> getProductsByCategory(String category);
}
