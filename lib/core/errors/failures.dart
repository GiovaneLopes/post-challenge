import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final List properties;
  const Failure(this.message, [this.properties = const []]);

  @override
  List<Object?> get props => [message, properties];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class PostFailure extends Failure {
  const PostFailure(super.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}
