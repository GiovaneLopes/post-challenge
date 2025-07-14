import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import 'package:post_challenge/core/usecases/usecase.dart';
import 'package:post_challenge/features/auth/domain/usecases/login_usecase.dart';
import 'package:post_challenge/features/auth/domain/usecases/logout_usecase.dart';
import 'package:post_challenge/features/auth/domain/usecases/get_user_usecase.dart';

part './auth_event.dart';
part './auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetUserUsecase getUserUsecase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.getUserUsecase,
    required this.loginUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<InitializeEvent>(_initialize);
    on<LoginWithEmailAndPasswordEvent>(_onLoginWithEmailAndPassword);
    on<LogoutEvent>(_onLogout);
    add(InitializeEvent());
  }

  UserEntity? user;

  Future<void> _initialize(
      InitializeEvent event, Emitter<AuthState> emit) async {
    final userOrFailure = await getUserUsecase(NoParams());
    userOrFailure.fold(
      (failure) => emit(AuthError(failure.message)),
      (userEntity) {
        if (userEntity != null) {
          user = userEntity;
          emit(AuthSuccess(userEntity));
        } else {
          emit(AuthInitial());
        }
      },
    );
  }

  Future<void> _onLoginWithEmailAndPassword(
      LoginWithEmailAndPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUseCase(AuthParams(
      email: event.email,
      password: event.password,
    ));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (userResponse) {
        user = userResponse;
        emit(AuthSuccess(userResponse));
      },
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(LogoutLoading());
    final result = await logoutUseCase(NoParams());
    result.fold(
      (failure) => emit(LogoutError(failure.message)),
      (_) => emit(LogoutSuccess()),
    );
  }
}
