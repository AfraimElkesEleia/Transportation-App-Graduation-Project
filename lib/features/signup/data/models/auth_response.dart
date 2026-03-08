import 'package:transportation_app/features/signup/data/models/user_model.dart';
import 'package:transportation_app/features/signup/domain/entities/auth_response.dart';

class AuthResponseModel extends AuthResponseEntity {
   const AuthResponseModel({
    required super.accessToken,
    required super.refreshToken,
    required super.expiresAt,
    required super.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
