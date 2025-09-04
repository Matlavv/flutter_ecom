import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<UserEntity> call(String email, String password, String displayName) {
    return _repository.createUserWithEmailAndPassword(
        email, password, displayName);
  }
}
