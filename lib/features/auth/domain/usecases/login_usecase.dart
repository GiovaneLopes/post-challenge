import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import 'package:post_challenge/core/usecases/usecase.dart';
import 'package:post_challenge/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase implements UseCase<UserEntity, AuthParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(AuthParams params) async {
    return await repository.signInWithEmailAndPassword(
      params.email,
      params.password,
    );
  }
}

class AuthParams extends Equatable {
  final String email;
  final String password;

  const AuthParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
