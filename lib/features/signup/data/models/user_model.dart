import 'package:transportation_app/features/signup/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.userId,
    required super.email,
    required super.fullName,
    required super.phoneNumber,
    required super.gender,
    required super.countryCode,
    required super.countryName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as int,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      gender: json['gender'] as String,
      countryCode: json['countryCode'] as String,
      countryName: json['countryName'] as String,
    );
  }
}
