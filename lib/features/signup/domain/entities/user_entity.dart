import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int userId;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String gender;
  final String countryCode;
  final String countryName;

  const UserEntity({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.gender,
    required this.countryCode,
    required this.countryName,
  });

  @override
  List<Object?> get props => [
    userId,
    email,
  ];
}
