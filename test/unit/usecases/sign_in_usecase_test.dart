import 'package:flutter_ecom/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_ecom/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_ecom/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Stream<UserEntity?> get authStateChanges => throw UnimplementedError();

  @override
  UserEntity? get currentUser => throw UnimplementedError();

  @override
  Future<UserEntity> signInWithEmailAndPassword(
      String email, String password) async {
    if (email == 'test@example.com' && password == 'password123') {
      return const UserEntity(
        id: '1',
        email: 'test@example.com',
        displayName: 'Test User',
      );
    }
    throw Exception('Invalid credentials');
  }

  @override
  Future<UserEntity> createUserWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    throw UnimplementedError();
  }
}

void main() {
  group('SignInUseCase', () {
    late SignInUseCase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = SignInUseCase(mockRepository);
    });

    test('should return user when credentials are valid', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';

      // Act
      final result = await useCase.call(email, password);

      // Assert
      expect(result.id, '1');
      expect(result.email, 'test@example.com');
      expect(result.displayName, 'Test User');
    });

    test('should throw exception when credentials are invalid', () async {
      // Arrange
      const email = 'wrong@example.com';
      const password = 'wrongpassword';

      // Act & Assert
      expect(
        () => useCase.call(email, password),
        throwsA(isA<Exception>()),
      );
    });
  });
}
