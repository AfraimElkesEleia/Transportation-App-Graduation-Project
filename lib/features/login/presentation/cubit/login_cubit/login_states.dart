import 'package:equatable/equatable.dart';
import 'package:transportation_app/features/signup/domain/entities/auth_response.dart';

sealed class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}
class LoginInitial  extends LoginState {}
class LoginLoading  extends LoginState {}

class LoginSuccess extends LoginState {
  final AuthResponseEntity authResponse;
  const LoginSuccess(this.authResponse);
  @override
  List<Object> get props => [authResponse];
}

class LoginFailure extends LoginState {
  final String       message;
  final List<String> errors;
  const LoginFailure({required this.message, this.errors = const []});
  @override
  List<Object> get props => [message, errors];
}