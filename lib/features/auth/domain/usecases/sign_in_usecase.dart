import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  Future<UserEntity> call(String email, String password) {
    return _repository.signInWithEmailAndPassword(email, password);
  }
}
