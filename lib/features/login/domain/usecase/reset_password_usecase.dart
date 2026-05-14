import 'package:equatable/equatable.dart';
import 'package:transportation_app/core/usecases/usecase.dart';
import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/login/domain/repositories/login_repository.dart';

class ResetPasswordUsecase extends Usecase<void, ResetPasswordParams> {
  final LoginRepository loginRepository;

  ResetPasswordUsecase({required this.loginRepository});

  @override
  ResultVoid call(ResetPasswordParams params) {
    return loginRepository.resetPassword(
      email: params.email,
      token: params.token,
      newPassword: params.newPassword,
      confirmPassword: params.confirmPassword,
    );
  }
}

class ResetPasswordParams extends Equatable {
  final String email;
  final String token;
  final String newPassword;
  final String confirmPassword;

  const ResetPasswordParams({
    required this.email,
    required this.token,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [email, token];
}
