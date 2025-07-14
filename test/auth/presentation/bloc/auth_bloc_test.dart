import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:post_challenge/core/errors/failures.dart';
import 'package:post_challenge/core/usecases/usecase.dart';
import 'package:post_challenge/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:post_challenge/features/auth/domain/entities/user_entity.dart';
import 'package:post_challenge/features/auth/domain/usecases/login_usecase.dart';
import 'package:post_challenge/features/auth/domain/usecases/logout_usecase.dart';
import 'package:post_challenge/features/auth/domain/usecases/get_user_usecase.dart';

class MockGetUserUsecase extends Mock implements GetUserUsecase {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  late AuthBloc bloc;
  late MockGetUserUsecase mockGetUserUsecase;
  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;

  setUp(() {
    mockGetUserUsecase = MockGetUserUsecase();
    mockLoginUseCase = MockLoginUseCase();
    mockLogoutUseCase = MockLogoutUseCase();

    bloc = AuthBloc(
      getUserUsecase: mockGetUserUsecase,
      loginUseCase: mockLoginUseCase,
      logoutUseCase: mockLogoutUseCase,
    );
  });

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(const AuthParams(
      password: 'password',
      email: 'test@test.com',
    ));
  });

  const user = UserEntity(uid: '1', email: 'test@test.com', name: 'Test User');

  group('AuthBloc', () {
    test('initial state is AuthInitial', () {
      expect(bloc.state, isA<AuthInitial>());
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthInitial] when InitializeEvent returns null user',
      build: () => bloc,
      setUp: () => when(() => mockGetUserUsecase(any()))
          .thenAnswer((_) async => const Right(null)),
      act: (bloc) => bloc.add(InitializeEvent()),
      wait: const Duration(seconds: 2),
      expect: () => [
        AuthInitial(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthSuccess] when InitializeEvent returns user',
      build: () => bloc,
      setUp: () => when(() => mockGetUserUsecase(any()))
          .thenAnswer((_) async => const Right(user)),
      act: (bloc) => bloc.add(InitializeEvent()),
      wait: const Duration(seconds: 2),
      expect: () => [AuthSuccess(user)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthError] when InitializeEvent returns failure',
      build: () => bloc,
      setUp: () => when(() => mockGetUserUsecase(any()))
          .thenAnswer((_) async => const Left(AuthFailure('error'))),
      act: (bloc) => bloc.add(InitializeEvent()),
      wait: const Duration(seconds: 2),
      expect: () => [AuthError('error')],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] on successful login',
      build: () => bloc,
      setUp: () => when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => const Right(user)),
      act: (bloc) => bloc.add(LoginWithEmailAndPasswordEvent(
        email: 'test@test.com',
        password: 'password',
      )),
      expect: () => [
        AuthLoading(),
        AuthSuccess(user),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] on failed login',
      build: () => bloc,
      setUp: () => when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => const Left(AuthFailure('login error'))),
      act: (bloc) => bloc.add(LoginWithEmailAndPasswordEvent(
        email: 'test@test.com',
        password: 'wrong',
      )),
      expect: () => [
        AuthLoading(),
        AuthError('login error'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [LogoutLoading, LogoutSuccess] on successful logout',
      build: () => bloc,
      setUp: () => when(() => mockLogoutUseCase(any()))
          .thenAnswer((_) async => const Right(unit)),
      act: (bloc) => bloc.add(LogoutEvent()),
      expect: () => [
        LogoutLoading(),
        LogoutSuccess(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [LogoutLoading, LogoutError] on failed logout',
      build: () => bloc,
      setUp: () => when(() => mockLogoutUseCase(any()))
          .thenAnswer((_) async => const Left(AuthFailure('logout error'))),
      act: (bloc) => bloc.add(LogoutEvent()),
      expect: () => [
        LogoutLoading(),
        LogoutError('logout error'),
      ],
    );
  });
}
