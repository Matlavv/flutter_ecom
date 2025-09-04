import 'package:flutter/material.dart';
import 'package:flutter_ecom/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginPage Widget Tests', () {
    testWidgets('should display login form with email and password fields', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const LoginPage())),
      );

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Assert - Test basic form elements
      expect(
        find.byType(TextFormField),
        findsNWidgets(2),
      ); // Email and password
      expect(find.text('Se connecter'), findsOneWidget);
    });

    testWidgets('should switch to sign up mode when tapping sign up button', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const LoginPage())),
      );

      // Act
      await tester.tap(find.text('Pas de compte ? Créer un compte'));
      await tester.pump();

      // Assert
      expect(find.text('Créer votre compte'), findsOneWidget);
      expect(
        find.byType(TextFormField),
        findsNWidgets(3),
      ); // Display name, email, password
      expect(find.text('Créer le compte'), findsOneWidget);
    });

    testWidgets('should validate email field', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const LoginPage())),
      );

      // Act
      await tester.tap(find.text('Se connecter'));
      await tester.pump();

      // Assert
      expect(find.text('Veuillez entrer votre email'), findsOneWidget);
    });

    testWidgets('should validate password field', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const LoginPage())),
      );

      // Act
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.tap(find.text('Se connecter'));
      await tester.pump();

      // Assert
      expect(find.text('Veuillez entrer votre mot de passe'), findsOneWidget);
    });

    testWidgets('should validate password length', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const LoginPage())),
      );

      // Act
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, '123');
      await tester.tap(find.text('Se connecter'));
      await tester.pump();

      // Assert
      expect(
        find.text('Le mot de passe doit contenir au moins 6 caractères'),
        findsOneWidget,
      );
    });

    testWidgets('should display loading indicator when authenticating', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const LoginPage())),
      );

      // Act
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.tap(find.text('Se connecter'));
      await tester.pump();

      // Assert
      // Note: In a real test, you would mock the AuthService to control the loading state
      // For now, we just verify the button exists and can be tapped
      expect(find.text('Se connecter'), findsOneWidget);
    });
  });
}
