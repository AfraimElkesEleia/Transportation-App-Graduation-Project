import 'package:equatable/equatable.dart';

sealed class PasswordStates extends Equatable {
  const PasswordStates();
  @override
  List<Object?> get props => [];
}

class PasswordInitial extends PasswordStates {}

class PasswordLoading extends PasswordStates {}

class PasswordSuccess extends PasswordStates {
  final String message;
  const PasswordSuccess(this.message);
  @override
  List<Object> get props => [message];
}

class PasswordFailure extends PasswordStates {
  final String message;
  final List<String> errors;
  const PasswordFailure({required this.message, this.errors = const []});
  @override
  List<Object> get props => [message, errors];
}
