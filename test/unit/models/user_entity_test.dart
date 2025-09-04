import 'package:flutter_ecom/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserEntity', () {
    test('should create a user entity with all properties', () {
      // Arrange
      final now = DateTime.now();
      final user = UserEntity(
        id: '1',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
        createdAt: now,
      );

      // Assert
      expect(user.id, '1');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
      expect(user.photoUrl, 'https://example.com/photo.jpg');
      expect(user.createdAt, now);
    });

    test('should create a user entity with minimal properties', () {
      // Arrange
      final user = UserEntity(
        id: '1',
        email: 'test@example.com',
      );

      // Assert
      expect(user.id, '1');
      expect(user.email, 'test@example.com');
      expect(user.displayName, null);
      expect(user.photoUrl, null);
      expect(user.createdAt, null);
    });

    test('should support equality comparison', () {
      // Arrange
      final now = DateTime.now();
      final user1 = UserEntity(
        id: '1',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
        createdAt: now,
      );

      final user2 = UserEntity(
        id: '1',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
        createdAt: now,
      );

      final user3 = UserEntity(
        id: '2',
        email: 'different@example.com',
        displayName: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
        createdAt: now,
      );

      // Assert
      expect(user1, equals(user2));
      expect(user1, isNot(equals(user3)));
    });
  });
}
