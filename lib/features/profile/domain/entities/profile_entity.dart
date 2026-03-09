import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final int     userId;
  final String  email;
  final String  fullName;
  final String  phoneNumber;
  final String  countryCode;
  final String  countryName;
  final String? profilePictureUrl;

  final int?    totalTrips;
  final double? totalDistanceKm;
  final int?    loyaltyPoints;

  const ProfileEntity({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.countryCode,
    required this.countryName,
    this.profilePictureUrl,
    this.totalTrips,
    this.totalDistanceKm,
    this.loyaltyPoints,
  });

  @override
  List<Object?> get props => [userId, email];
}