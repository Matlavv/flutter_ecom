import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<UserModel?> get authStateChanges;
  UserModel? get currentUser;
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> createUserWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  );
  Future<UserModel> signInWithGoogle();
  Future<UserModel> updateUserProfile({
    String? displayName,
    String? photoUrl,
  });
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  @override
  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().asyncMap<UserModel?>((firebaseUser) async {
      if (firebaseUser == null) return null;
      return await _getUserFromFirestore(firebaseUser.uid);
    });
  }

  @override
  UserModel? get currentUser {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Erreur lors de la connexion');
      }

      return await _getUserFromFirestore(credential.user!.uid);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<UserModel> createUserWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Erreur lors de la création du compte');
      }

      // Mettre à jour le profil utilisateur
      await credential.user!.updateDisplayName(displayName);

      // Créer le document utilisateur dans Firestore
      final user = UserModel(
        id: credential.user!.uid,
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(user.toJson());

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // Déclencher le flux d'authentification Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Connexion Google annulée par l\'utilisateur');
      }

      // Obtenir les détails d'authentification de la demande
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Créer une nouvelle credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Une fois connecté, retourner l'UserCredential
      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw Exception('Erreur lors de la connexion avec Google');
      }

      // Créer ou récupérer l'utilisateur depuis Firestore
      return await _getUserFromFirestore(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('People API has not been used')) {
        throw Exception('L\'API People de Google n\'est pas activée. '
            'Veuillez l\'activer dans Google Cloud Console : '
            'https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=330662716424');
      } else if (errorMessage.contains('PERMISSION_DENIED')) {
        throw Exception(
            'Permission refusée. Vérifiez la configuration de votre projet Google Cloud.');
      } else if (errorMessage.contains('CLIENT_ID')) {
        throw Exception(
            'Client ID Google non configuré correctement. Vérifiez votre configuration.');
      }
      throw Exception('Erreur lors de la connexion Google: $e');
    }
  }

  @override
  Future<UserModel> updateUserProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Mettre à jour le profil Firebase Auth
      await firebaseUser.updateDisplayName(displayName);
      if (photoUrl != null) {
        await firebaseUser.updatePhotoURL(photoUrl);
      }

      // Mettre à jour le document Firestore
      final updateData = <String, dynamic>{};
      if (displayName != null) updateData['displayName'] = displayName;
      if (photoUrl != null) updateData['photoUrl'] = photoUrl;

      if (updateData.isNotEmpty) {
        await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .update(updateData);
      }

      // Retourner l'utilisateur mis à jour
      return await _getUserFromFirestore(firebaseUser.uid);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du profil: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<UserModel> _getUserFromFirestore(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) {
      // Si l'utilisateur n'existe pas dans Firestore, le créer
      final firebaseUser = _auth.currentUser!;
      final user = UserModel(
        id: uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(uid).set(user.toJson());
      return user;
    }

    return UserModel.fromJson(doc.data()!);
  }

  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('Aucun utilisateur trouvé avec cet email');
      case 'wrong-password':
        return Exception('Mot de passe incorrect');
      case 'email-already-in-use':
        return Exception('Cet email est déjà utilisé');
      case 'weak-password':
        return Exception('Le mot de passe est trop faible');
      case 'invalid-email':
        return Exception('Email invalide');
      case 'user-disabled':
        return Exception('Ce compte a été désactivé');
      case 'too-many-requests':
        return Exception('Trop de tentatives. Réessayez plus tard');
      default:
        return Exception('Erreur d\'authentification: ${e.message}');
    }
  }
}
