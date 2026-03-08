import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final List<String> errors;

  const Failure({required this.message, this.errors = const []});

  @override
  List<Object> get props => [message, errors];
}
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.errors});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message = 'Unauthorized. Please login again.'});
}
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.errors});
}
class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'An unexpected error occurred'});
}
