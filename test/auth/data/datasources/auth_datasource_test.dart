import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:post_challenge/core/errors/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:post_challenge/features/auth/data/models/user_model.dart';
import 'package:post_challenge/features/auth/data/datasources/auth_datasource.dart';
// ignore_for_file: subtype_of_sealed_class


class MockFirebaseAuth extends Mock implements firebase_auth.FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockUser extends Mock implements firebase_auth.User {}

class MockUserCredential extends Mock implements firebase_auth.UserCredential {}

class MockCollectionReference<T> extends Mock
    implements CollectionReference<T> {}

class MockDocumentReference<T> extends Mock implements DocumentReference<T> {}

class MockDocumentSnapshot<T> extends Mock implements DocumentSnapshot<T> {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirestore;
  late FirebaseAuthDatasourceImpl datasource;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDocRef;
  late MockDocumentSnapshot<Map<String, dynamic>> mockDocSnap;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    datasource = FirebaseAuthDatasourceImpl(mockFirebaseAuth, mockFirestore);
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    mockCollection = MockCollectionReference<Map<String, dynamic>>();
    mockDocRef = MockDocumentReference<Map<String, dynamic>>();
    mockDocSnap = MockDocumentSnapshot<Map<String, dynamic>>();
  });

  group('signInWithEmailAndPassword', () {
    const email = 'test@email.com';
    const password = 'password123';
    const uid = 'user123';

    final userData = {
      'name': 'Test User',
      'photo': 'photo_url',
      'age': 30,
      'totalPosts': 5,
      'preferences': ['sports', 'music'],
    };

    setUp(() {
      when(() => mockUser.uid).thenReturn(uid);
      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc(uid)).thenReturn(mockDocRef);
      when(() => mockDocRef.get()).thenAnswer((_) async => mockDocSnap);
      when(() => mockDocSnap.data()).thenReturn(userData);
    });

    test('should return UserEntity on successful login', () async {
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          )).thenAnswer((_) async => mockUserCredential);

      final result =
          await datasource.signInWithEmailAndPassword(email, password);

      expect(result, isA<UserModel>());
      expect(result.name, userData['name']);
      expect(result.photo, userData['photo']);
      expect(result.age, userData['age']);
      expect(result.totalPosts, userData['totalPosts']);
      expect(result.preferences, userData['preferences']);
    });

    test('should throw AuthException on user-not-found', () async {
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
                email: email,
                password: password,
              ))
          .thenThrow(
              firebase_auth.FirebaseAuthException(code: 'user-not-found'));

      expect(
        () => datasource.signInWithEmailAndPassword(email, password),
        throwsA(isA<AuthException>()),
      );
    });

    test('should throw AuthException on wrong-password', () async {
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
                email: email,
                password: password,
              ))
          .thenThrow(
              firebase_auth.FirebaseAuthException(code: 'wrong-password'));

      expect(
        () => datasource.signInWithEmailAndPassword(email, password),
        throwsA(isA<AuthException>()),
      );
    });

    test('should throw AuthException on invalid-email', () async {
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
                email: email,
                password: password,
              ))
          .thenThrow(
              firebase_auth.FirebaseAuthException(code: 'invalid-email'));

      expect(
        () => datasource.signInWithEmailAndPassword(email, password),
        throwsA(isA<AuthException>()),
      );
    });

    test('should throw AuthException on user-disabled', () async {
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
                email: email,
                password: password,
              ))
          .thenThrow(
              firebase_auth.FirebaseAuthException(code: 'user-disabled'));

      expect(
        () => datasource.signInWithEmailAndPassword(email, password),
        throwsA(isA<AuthException>()),
      );
    });

    test('should throw AuthException if user is null', () async {
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          )).thenAnswer((_) async => mockUserCredential);
      when(() => mockUserCredential.user).thenReturn(null);

      expect(
        () => datasource.signInWithEmailAndPassword(email, password),
        throwsA(isA<AuthException>()),
      );
    });
  });

  group('signOut', () {
    test('should call signOut on FirebaseAuth', () async {
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      await datasource.signOut();

      verify(() => mockFirebaseAuth.signOut()).called(1);
    });

    test('should throw AuthException on FirebaseAuthException', () async {
      when(() => mockFirebaseAuth.signOut()).thenThrow(
        firebase_auth.FirebaseAuthException(
            code: 'error', message: 'Sign out error'),
      );

      expect(
        () => datasource.signOut(),
        throwsA(isA<AuthException>()),
      );
    });

    test('should throw AuthException on generic exception', () async {
      when(() => mockFirebaseAuth.signOut())
          .thenThrow(Exception('Generic error'));

      expect(
        () => datasource.signOut(),
        throwsA(isA<AuthException>()),
      );
    });
  });

  group('getCurrentUser', () {
    const uid = 'user123';
    final userData = {
      'name': 'Test User',
      'photo': 'photo_url',
      'age': 30,
      'totalPosts': 5,
      'preferences': ['sports', 'music'],
    };

    setUp(() {
      when(() => mockUser.uid).thenReturn(uid);
      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc(uid)).thenReturn(mockDocRef);
      when(() => mockDocRef.get()).thenAnswer((_) async => mockDocSnap);
      when(() => mockDocSnap.exists).thenReturn(true);
      when(() => mockDocSnap.data()).thenReturn(userData);
    });

    test('should return UserEntity if user is logged in and data exists',
        () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

      final result = await datasource.getCurrentUser();

      expect(result, isA<UserModel>());
      expect(result?.name, userData['name']);
    });

    test('should return null if no user is logged in', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      final result = await datasource.getCurrentUser();

      expect(result, isNull);
    });

    test('should return null if user data does not exist', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockDocSnap.exists).thenReturn(false);

      final result = await datasource.getCurrentUser();

      expect(result, isNull);
    });
  });
}
