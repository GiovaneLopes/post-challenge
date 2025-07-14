import 'package:dartz/dartz.dart';
import 'package:post_challenge/core/errors/failures.dart';
import 'package:post_challenge/core/usecases/usecase.dart';
import 'package:post_challenge/features/auth/domain/entities/user_entity.dart';
import 'package:post_challenge/features/auth/domain/repositories/auth_repository.dart';
 
class GetUserUsecase implements UseCase<UserEntity?, NoParams> {
  final AuthRepository repository;

  GetUserUsecase(this.repository);

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}
