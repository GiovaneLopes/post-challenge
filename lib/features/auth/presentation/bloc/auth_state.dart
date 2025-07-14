part of './auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserEntity user;

  AuthSuccess(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

class LogoutLoading extends AuthState {}

class LogoutSuccess extends AuthState {}

class LogoutError extends AuthState {
  final String message;

  LogoutError(this.message);
  @override
  List<Object?> get props => [message];
}
