class ServerException implements Exception {
  final String message;
  final List<String> errors;
  final int? statusCode;

  ServerException({
    required this.message,
    this.errors = const [],
    this.statusCode,
  });
}

class NetworkException implements Exception {}
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException({this.message = 'Unauthorized'});
}
