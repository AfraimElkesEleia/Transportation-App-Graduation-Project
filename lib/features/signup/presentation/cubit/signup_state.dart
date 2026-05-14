import 'package:equatable/equatable.dart';
import 'package:transportation_app/features/signup/domain/entities/auth_response.dart';

sealed class SignupState extends Equatable {
  const SignupState();
  @override
  List<Object?> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final AuthResponseEntity authResponse;
  const SignupSuccess(this.authResponse);
  @override
  List<Object> get props => [authResponse];
}

class EmailVerificationSent extends SignupState {
  const EmailVerificationSent();
}
class SignupFailure extends SignupState {
  final String message;
  final List<String> errors; 
  const SignupFailure({required this.message, this.errors = const []});
  @override
  List<Object> get props => [message, errors];
}
