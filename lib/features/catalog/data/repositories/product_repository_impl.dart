import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl({required ProductRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Stream<List<ProductEntity>> getProducts() {
    return _remoteDataSource.getProducts().map(
          (products) => products.map((product) => product.toEntity()).toList(),
        );
  }

  @override
  Future<ProductEntity?> getProductById(String id) async {
    final product = await _remoteDataSource.getProductById(id);
    return product?.toEntity();
  }

  @override
  Future<String> createProduct(ProductEntity product) {
    return _remoteDataSource.createProduct(ProductModel.fromEntity(product));
  }

  @override
  Future<void> updateProduct(ProductEntity product) {
    return _remoteDataSource.updateProduct(ProductModel.fromEntity(product));
  }

  @override
  Future<void> deleteProduct(String id) {
    return _remoteDataSource.deleteProduct(id);
  }

  @override
  Stream<List<ProductEntity>> searchProducts(String query) {
    return _remoteDataSource.searchProducts(query).map(
          (products) => products.map((product) => product.toEntity()).toList(),
        );
  }

  @override
  Stream<List<ProductEntity>> getProductsByCategory(String category) {
    return _remoteDataSource.getProductsByCategory(category).map(
          (products) => products.map((product) => product.toEntity()).toList(),
        );
  }
}
