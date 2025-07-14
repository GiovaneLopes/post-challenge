import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:post_challenge/core/errors/failures.dart';
import 'package:post_challenge/features/auth/domain/entities/user_entity.dart';
import 'package:post_challenge/features/auth/domain/usecases/login_usecase.dart';
import 'package:post_challenge/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = LoginUseCase(mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tAuthParams = AuthParams(email: tEmail, password: tPassword);
  const tUserEntity = UserEntity(uid: '1', email: tEmail);

  test('should return UserEntity when login is successful', () async {
    when(() => mockAuthRepository.signInWithEmailAndPassword(any(), any()))
        .thenAnswer((_) async => const Right(tUserEntity));
    final result = await useCase(tAuthParams);
    expect(result, const Right(tUserEntity));
    verify(
        () => mockAuthRepository.signInWithEmailAndPassword(tEmail, tPassword));
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return Failure when login fails', () async {
    const tFailure = PostFailure('error');
    when(() => mockAuthRepository.signInWithEmailAndPassword(any(), any()))
        .thenAnswer((_) async => const Left(tFailure));
    final result = await useCase(tAuthParams);
    expect(result, const Left(tFailure));
    verify(
        () => mockAuthRepository.signInWithEmailAndPassword(tEmail, tPassword));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
