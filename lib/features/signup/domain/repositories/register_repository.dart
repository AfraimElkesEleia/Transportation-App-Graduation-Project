import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/signup/domain/entities/auth_response.dart';

abstract class RegisterRepository {
  ResultFuture<AuthResponseEntity> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String firstName,
    required String lastName,
    required String familyName,
    required int gender,
    required String dateOfBirth,
    required String countryCode,
    String? nationalIdNumber,
  });
}
