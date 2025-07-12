import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/errors/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

abstract class AuthDatasource {
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Stream<UserEntity?> get authStateChanges;
}

class FirebaseAuthDatasourceImpl implements AuthDatasource {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  FirebaseAuthDatasourceImpl(this._firebaseAuth);

  @override
  Future<UserEntity> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        return UserModel.fromFirebaseUser(credential.user!);
      } else {
        throw const AuthException('User not found after login.');
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw const AuthException(
            'Invalid credentials. Please check your email and password.');
      } else if (e.code == 'invalid-email') {
        throw const AuthException('The email format is invalid.');
      } else if (e.code == 'user-disabled') {
        throw const AuthException('This user has been disabled.');
      }
      throw AuthException(
          e.message ?? 'An unknown authentication error occurred.');
    } catch (e) {
      throw AuthException('Failed to login: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(
          e.message ?? 'An unknown error occurred while signing out.');
    } catch (e) {
      throw AuthException('Failed to sign out: ${e.toString()}');
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    });
  }
}
