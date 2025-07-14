import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:post_challenge/core/errors/failures.dart';
import 'package:post_challenge/core/usecases/usecase.dart';
import 'package:post_challenge/features/auth/domain/entities/user_entity.dart';
import 'package:post_challenge/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:post_challenge/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late GetUserUsecase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = GetUserUsecase(mockAuthRepository);
  });

  const tUserEntity =
      UserEntity(uid: '1', name: 'Test User', email: 'test@email.com');

  test('should get current user from the repository', () async {
    // arrange
    when(() => mockAuthRepository.getCurrentUser())
        .thenAnswer((_) async => const Right(tUserEntity));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, const Right(tUserEntity));
    verify(() => mockAuthRepository.getCurrentUser());
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return Failure when repository fails', () async {
    // arrange
    when(() => mockAuthRepository.getCurrentUser())
        .thenAnswer((_) async => const Left(PostFailure('error')));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, const Left(PostFailure('error')));
    verify(() => mockAuthRepository.getCurrentUser());
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return null user when no user is logged in', () async {
    // arrange
    when(() => mockAuthRepository.getCurrentUser())
        .thenAnswer((_) async => const Right(null));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, const Right(null));
    verify(() => mockAuthRepository.getCurrentUser());
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
