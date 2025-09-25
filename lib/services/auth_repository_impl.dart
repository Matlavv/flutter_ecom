import '../models/user_entity.dart';
import 'auth_remote_datasource.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Stream<UserEntity?> get authStateChanges {
    return _remoteDataSource.authStateChanges.map((user) => user?.toEntity());
  }

  @override
  UserEntity? get currentUser {
    return _remoteDataSource.currentUser?.toEntity();
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final user = await _remoteDataSource.signInWithEmailAndPassword(
      email,
      password,
    );
    return user.toEntity();
  }

  @override
  Future<UserEntity> createUserWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    final user = await _remoteDataSource.createUserWithEmailAndPassword(
      email,
      password,
      displayName,
    );
    return user.toEntity();
  }

  @override
  Future<UserEntity> updateUserProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    final user = await _remoteDataSource.updateUserProfile(
      displayName: displayName,
      photoUrl: photoUrl,
    );
    return user.toEntity();
  }

  @override
  Future<void> signOut() {
    return _remoteDataSource.signOut();
  }
}
