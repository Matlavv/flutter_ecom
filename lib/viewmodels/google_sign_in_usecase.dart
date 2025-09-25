import '../models/user_entity.dart';
import '../services/auth_repository.dart';

class GoogleSignInUseCase {
  final AuthRepository _authRepository;

  GoogleSignInUseCase(this._authRepository);

  Future<UserEntity> call() async {
    return await _authRepository.signInWithGoogle();
  }
}
