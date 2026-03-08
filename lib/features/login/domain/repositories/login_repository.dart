import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/signup/domain/entities/auth_response.dart';

abstract class LoginRepository {
  ResultFuture<AuthResponseEntity> login({
    required String email,
    required String password,
    String? deviceInfo,
  });
  ResultVoid forgotPassword({required String email});
  ResultVoid resetPassword({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  });
 ResultVoid changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
  ResultFuture<AuthResponseEntity> refreshToken({
    required String refreshToken,
  });
}
