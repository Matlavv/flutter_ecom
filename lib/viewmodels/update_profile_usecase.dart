import '../models/user_entity.dart';
import '../services/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository _authRepository;

  UpdateProfileUseCase(this._authRepository);

  Future<UserEntity> call({
    String? displayName,
    String? photoUrl,
  }) async {
    return await _authRepository.updateUserProfile(
      displayName: displayName,
      photoUrl: photoUrl,
    );
  }
}
