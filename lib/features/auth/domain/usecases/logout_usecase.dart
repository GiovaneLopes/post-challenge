import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:post_challenge/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<Unit, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await repository.signOut();
  }
}
