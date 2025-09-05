import '../models/product_entity.dart';
import '../services/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository _repository;

  GetProductsUseCase(this._repository);

  Stream<List<ProductEntity>> call() {
    return _repository.getProducts();
  }
}
