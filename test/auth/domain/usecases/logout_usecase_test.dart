import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:post_challenge/core/errors/failures.dart';
import 'package:post_challenge/core/usecases/usecase.dart';
import 'package:post_challenge/features/auth/domain/usecases/logout_usecase.dart';
import 'package:post_challenge/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LogoutUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LogoutUseCase(mockAuthRepository);
  });

  test(
      'should call signOut on the repository and return Right(Unit) on success',
      () async {
    when(() => mockAuthRepository.signOut())
        .thenAnswer((_) async => const Right(unit));
    final result = await usecase(NoParams());
    expect(result, const Right(unit));
    verify(() => mockAuthRepository.signOut());
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return Left(Failure) when repository.signOut fails', () async {
    const failure = PostFailure('error');
    when(() => mockAuthRepository.signOut())
        .thenAnswer((_) async => const Left(failure));
    final result = await usecase(NoParams());
    expect(result, const Left(failure));
    verify(() => mockAuthRepository.signOut());
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
