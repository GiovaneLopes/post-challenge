import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import 'package:post_challenge/features/auth/data/datasources/auth_datasource.dart';
import 'package:post_challenge/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource loginDatasource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl(
    this.loginDatasource,
    this.networkInfo,
  );

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    final user = await loginDatasource.authStateChanges.first;
    return Right(user);
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
      String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await loginDatasource.signInWithEmailAndPassword(
          email,
          password,
        );
        return Right(user);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on UnexpectedException catch (e) {
        return Left(UnexpectedFailure(e.message));
      } catch (e) {
        return Left(UnexpectedFailure(
            'Unexpected error during sign in: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure(
          'No internet connection. Please check your connection.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    if (await networkInfo.isConnected) {
      try {
        await loginDatasource.signOut();
        return const Right(unit);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on UnexpectedException catch (e) {
        return Left(UnexpectedFailure(e.message));
      } catch (e) {
        return Left(UnexpectedFailure(
            'Unexpected error during sign out: ${e.toString()}'));
      }
    } else {
      return const Left(
          NetworkFailure('No internet connection. Unable to sign out.'));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return loginDatasource.authStateChanges;
  }
}
