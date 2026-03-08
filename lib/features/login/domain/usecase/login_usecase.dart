import 'package:equatable/equatable.dart';
import 'package:transportation_app/core/usecases/usecase.dart';
import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/login/domain/repositories/login_repository.dart';
import 'package:transportation_app/features/signup/domain/entities/auth_response.dart';

class LoginUsecase extends Usecase<AuthResponseEntity, LoginParams> {
  final LoginRepository loginRepository;

  LoginUsecase({required this.loginRepository});
  @override
  ResultFuture<AuthResponseEntity> call(LoginParams params) {
    return loginRepository.login(
      email: params.email,
      password: params.password,
      deviceInfo: params.deviceInfo
    );
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;
  final String? deviceInfo;

  const LoginParams({
    required this.email,
    required this.password,
    this.deviceInfo,
  });

  @override
  List<Object?> get props => [email, password];
}
