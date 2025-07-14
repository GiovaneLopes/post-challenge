import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:post_challenge/core/errors/failures.dart';
import 'package:post_challenge/core/errors/exceptions.dart';
import 'package:post_challenge/core/network/network_info.dart';
import 'package:post_challenge/features/auth/domain/entities/user_entity.dart';
import 'package:post_challenge/features/auth/data/datasources/auth_datasource.dart';
import 'package:post_challenge/features/auth/data/repositories/auth_repository_impl.dart';


class MockAuthDatasource extends Mock implements AuthDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthDatasource mockDatasource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockDatasource = MockAuthDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(mockDatasource, mockNetworkInfo);
  });

  const tEmail = 'test@email.com';
  const tPassword = 'password123';
  const tUser = UserEntity(uid: '1', email: tEmail);

  group('getCurrentUser', () {
    test('should return user from datasource', () async {
      when(() => mockDatasource.getCurrentUser())
          .thenAnswer((_) async => tUser);

      final result = await repository.getCurrentUser();

      expect(result, const Right(tUser));
      verify(() => mockDatasource.getCurrentUser());
    });
  });

  group('signInWithEmailAndPassword', () {
    void setNetworkConnected() =>
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

    void setNetworkDisconnected() =>
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

    test('should check network connectivity', () async {
      setNetworkConnected();
      when(() => mockDatasource.signInWithEmailAndPassword(any(), any()))
          .thenAnswer((_) async => tUser);

      await repository.signInWithEmailAndPassword(tEmail, tPassword);

      verify(() => mockNetworkInfo.isConnected);
    });

    test('should return user when sign in succeeds', () async {
      setNetworkConnected();
      when(() => mockDatasource.signInWithEmailAndPassword(tEmail, tPassword))
          .thenAnswer((_) async => tUser);

      final result =
          await repository.signInWithEmailAndPassword(tEmail, tPassword);

      expect(result, const Right(tUser));
      verify(
          () => mockDatasource.signInWithEmailAndPassword(tEmail, tPassword));
    });

    test('should return AuthFailure on AuthException', () async {
      setNetworkConnected();
      when(() => mockDatasource.signInWithEmailAndPassword(any(), any()))
          .thenThrow(const AuthException('Auth error'));

      final result =
          await repository.signInWithEmailAndPassword(tEmail, tPassword);

      expect(result, const Left(AuthFailure('Auth error')));
    });

    test('should return ServerFailure on ServerException', () async {
      setNetworkConnected();
      when(() => mockDatasource.signInWithEmailAndPassword(any(), any()))
          .thenThrow(const ServerException('Server error'));

      final result =
          await repository.signInWithEmailAndPassword(tEmail, tPassword);

      expect(result, const Left(ServerFailure('Server error')));
    });

    test('should return UnexpectedFailure on UnexpectedException', () async {
      setNetworkConnected();
      when(() => mockDatasource.signInWithEmailAndPassword(any(), any()))
          .thenThrow(const UnexpectedException('Unexpected error'));

      final result =
          await repository.signInWithEmailAndPassword(tEmail, tPassword);

      expect(result, const Left(UnexpectedFailure('Unexpected error')));
    });

    test('should return UnexpectedFailure on unknown exception', () async {
      setNetworkConnected();
      when(() => mockDatasource.signInWithEmailAndPassword(any(), any()))
          .thenThrow(Exception('Unknown'));

      final result =
          await repository.signInWithEmailAndPassword(tEmail, tPassword);

      expect(
        result,
        isA<Left<Failure, UserEntity>>().having((l) => l.value.message,
            'message', contains('Unexpected error during sign in')),
      );
    });

    test('should return NetworkFailure when offline', () async {
      setNetworkDisconnected();

      final result =
          await repository.signInWithEmailAndPassword(tEmail, tPassword);

      expect(result, isA<Left<Failure, UserEntity>>());
      expect(
        (result as Left).value,
        isA<NetworkFailure>(),
      );
    });
  });

  group('signOut', () {
    void setNetworkConnected() =>
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

    void setNetworkDisconnected() =>
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

    test('should check network connectivity', () async {
      setNetworkConnected();
      when(() => mockDatasource.signOut()).thenAnswer((_) async {});

      await repository.signOut();

      verify(() => mockNetworkInfo.isConnected);
    });

    test('should return unit when sign out succeeds', () async {
      setNetworkConnected();
      when(() => mockDatasource.signOut()).thenAnswer((_) async {});

      final result = await repository.signOut();

      expect(result, const Right(unit));
      verify(() => mockDatasource.signOut());
    });

    test('should return AuthFailure on AuthException', () async {
      setNetworkConnected();
      when(() => mockDatasource.signOut())
          .thenThrow(const AuthException('Sign out error'));

      final result = await repository.signOut();

      expect(result, const Left(AuthFailure('Sign out error')));
    });

    test('should return UnexpectedFailure on UnexpectedException', () async {
      setNetworkConnected();
      when(() => mockDatasource.signOut())
          .thenThrow(const UnexpectedException('Unexpected error'));

      final result = await repository.signOut();

      expect(result, const Left(UnexpectedFailure('Unexpected error')));
    });

    test('should return UnexpectedFailure on unknown exception', () async {
      setNetworkConnected();
      when(() => mockDatasource.signOut()).thenThrow(Exception('Unknown'));

      final result = await repository.signOut();

      expect(
        result,
        isA<Left<Failure, Unit>>().having((l) => l.value.message, 'message',
            contains('Unexpected error during sign out')),
      );
    });

    test('should return NetworkFailure when offline', () async {
      setNetworkDisconnected();

      final result = await repository.signOut();

      expect(result, isA<Left<Failure, Unit>>());
      expect(
        (result as Left).value,
        isA<NetworkFailure>(),
      );
    });
  });
}
