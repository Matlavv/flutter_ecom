import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class CreateProductUseCase {
  final ProductRepository _repository;

  CreateProductUseCase(this._repository);

  Future<String> call(ProductEntity product) {
    return _repository.createProduct(product);
  }
}
