import 'package:equatable/equatable.dart';
import 'package:transportation_app/core/usecases/usecase.dart';
import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/login/domain/repositories/login_repository.dart';

class ForgotPasswordUsecase extends Usecase <void,ForgetPasswordParams>{
  final LoginRepository loginRepository;

  ForgotPasswordUsecase({required this.loginRepository});

  @override
  ResultVoid call(params) {
   return loginRepository.forgotPassword(email: params.email);
  }
}

class ForgetPasswordParams extends Equatable {
  final String email;

  const ForgetPasswordParams({required this.email});
  
  @override
  List<Object?> get props => [email];
}
