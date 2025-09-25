import '../models/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  UserEntity? get currentUser;
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);
  Future<UserEntity> createUserWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  );
  Future<UserEntity> signInWithGoogle();
  Future<UserEntity> updateUserProfile({
    String? displayName,
    String? photoUrl,
  });
  Future<void> signOut();
}
