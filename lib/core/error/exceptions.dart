class ServerException implements Exception {
  final String message;
  final List<String> errors;
  final int? statusCode;

  ServerException({
    required this.message,
    this.errors = const [],
    this.statusCode,
  });

  @override
  String toString() {
    if (errors.isNotEmpty) {
      return '$message\n${errors.join('\n')}';
    }
    return message;
  }
}

class NetworkException implements Exception {
  @override
  String toString() => 'Please check your internet connection.';
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException({this.message = 'Unauthorized'});

  @override
  String toString() => message;
}
