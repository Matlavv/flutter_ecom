import '../models/product_entity.dart';
import '../services/product_repository.dart';

class CreateProductUseCase {
  final ProductRepository _repository;

  CreateProductUseCase(this._repository);

  Future<String> call(ProductEntity product) {
    return _repository.createProduct(product);
  }
}
