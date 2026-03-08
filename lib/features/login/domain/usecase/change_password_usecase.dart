import 'package:equatable/equatable.dart';
import 'package:transportation_app/core/usecases/usecase.dart';
import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/login/domain/repositories/login_repository.dart';

class ChangePasswordUseCase extends Usecase<void, ChangePasswordParams> {
  final LoginRepository repository;
  ChangePasswordUseCase(this.repository);

  @override
  ResultVoid call(params) {
    return repository.changePassword(
      currentPassword: params.currentPassword,
      newPassword:     params.newPassword,
      confirmPassword: params.confirmPassword,
    );
  }
}

class ChangePasswordParams extends Equatable {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [currentPassword, newPassword];
}