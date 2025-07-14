import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/errors/exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

abstract class AuthDatasource {
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
}

class FirebaseAuthDatasourceImpl implements AuthDatasource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDatasourceImpl(this._firebaseAuth, this._firestore);

  @override
  Future<UserEntity> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final result =
          await _firestore.collection('users').doc(credential.user?.uid).get();
      if (credential.user != null) {
        return UserModel.fromFirebaseUser(credential.user!).copyWith(
            name: result.data()?['name'],
            photo: result.data()?['photo'],
            age: result.data()?['age'],
            totalPosts: result.data()?['totalPosts'],
            preferences: result.data()?['preferences']?.cast<String>());
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
  Future<UserEntity?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final result = await _firestore.collection('users').doc(user.uid).get();
      if (result.exists) {
        return UserModel.fromFirebaseUser(user).copyWith(
          name: result.data()?['name'],
          photo: result.data()?['photo'],
          age: result.data()?['age'],
          totalPosts: result.data()?['totalPosts'],
          preferences: result.data()?['preferences']?.cast<String>(),
        );
      }
    }
    return null;
  }
}
