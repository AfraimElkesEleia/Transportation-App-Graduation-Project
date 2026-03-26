import 'package:equatable/equatable.dart';
import 'package:transportation_app/core/usecases/usecase.dart';
import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/signup/domain/entities/auth_response.dart';
import 'package:transportation_app/features/signup/domain/repositories/register_repository.dart';

class RegisterUseCase extends Usecase<AuthResponseEntity, RegisterParams> {
  final RegisterRepository repository;
  RegisterUseCase(this.repository);
  @override
  ResultFuture<AuthResponseEntity> call(RegisterParams params) {
    return repository.register(
      email: params.email,
      password: params.password,
      confirmPassword: params.confirmPassword,
      phoneNumber: params.phoneNumber,
      firstName: params.firstName,
      lastName: params.lastName,
      familyName: params.familyName,
      gender: params.gender,
      dateOfBirth: params.dateOfBirth,
      countryCode: params.countryCode,
      nationalIdNumber: params.nationalIdNumber,
    );
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String familyName;
  final int gender;
  final String dateOfBirth;
  final String countryCode;
  final String? nationalIdNumber;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.familyName,
    required this.gender,
    required this.dateOfBirth,
    required this.countryCode,
    this.nationalIdNumber,
  });

  @override
  List<Object?> get props => [email, phoneNumber];
}
