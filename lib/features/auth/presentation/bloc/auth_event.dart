part of './auth_bloc.dart';

abstract class AuthEvent {}

class InitializeEvent extends AuthEvent {}

class LoginWithEmailAndPasswordEvent extends AuthEvent {
  final String email;
  final String password;

  LoginWithEmailAndPasswordEvent({
    required this.email,
    required this.password,
  });
}

class LogoutEvent extends AuthEvent {}
