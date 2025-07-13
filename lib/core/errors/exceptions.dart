class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
  @override
  String toString() => 'ServerException: $message';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
  @override
  String toString() => 'NetworkException: $message';
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => 'AuthException: $message';
}

class PostException implements Exception {
  final String message;
  const PostException(this.message);
  @override
  String toString() => 'PostException: $message';
}

class UnexpectedException implements Exception {
  final String message;

  const UnexpectedException(this.message);

  @override
  String toString() => 'UnexpectedException: $message';
}
