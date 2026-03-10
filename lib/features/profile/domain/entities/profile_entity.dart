import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final int userId;
  final String firstName;
  final String lastName;
  final String familyName;
  final String email;
  final String phoneNumber;
  final String gender;
  final String countryCode;
  final String countryName;
  final String? profilePictureUrl;
  final int? totalTrips;
  final double? totalDistanceKm;
  final double? walletBalance;
  const ProfileEntity({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.familyName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.countryCode,
    required this.countryName,
    this.profilePictureUrl,
    this.totalTrips,
    this.totalDistanceKm,
    this.walletBalance,
  });

  ProfileEntity copyWith({
    String? firstName,
    String? lastName,
    String? familyName,
    String? email,
    String? phoneNumber,
    String? profilePictureUrl,
    int? totalTrips,
    double? totalDistanceKm,
    double? walletBalance,
  }) {
    return ProfileEntity(
      userId: userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      familyName: familyName ?? this.familyName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender,
      countryCode: countryCode,
      countryName: countryName,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      totalTrips: totalTrips ?? this.totalTrips,
      totalDistanceKm: totalDistanceKm ?? this.totalDistanceKm,
      walletBalance: walletBalance ?? this.walletBalance,
    );
  }

  String get fullName =>
      '${firstName.capitalize()} ${lastName.capitalize()} ${familyName.capitalize()}'
          .trim();

  @override
  List<Object?> get props => [userId, email];
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
