import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.userId,
    required super.firstName,
    required super.lastName,
    required super.familyName,
    required super.email,
    required super.phoneNumber,
    required super.gender,
    required super.countryCode,
    required super.countryName,
    super.profilePictureUrl,
    super.totalTrips,
    super.totalDistanceKm,
    super.walletBalance,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId:            json['userId']               as int,
      firstName:         json['firstName']            as String,
      lastName:          json['lastName']             as String,
      familyName:        json['familyName']           as String,
      email:             json['email']                as String,
      phoneNumber:       json['phoneNumber']          as String,
      gender:            json['gender']               as String? ?? '',
      countryCode:       json['countryCode']          as String? ?? '',
      countryName:       json['countryName']          as String? ?? '',
      profilePictureUrl: json['profilePictureUrl']    as String?,
      totalTrips:        json['totalTripsCount']      as int?,
      totalDistanceKm:   (json['totalDistanceTraveled'] as num?)?.toDouble(),
      walletBalance:     (json['walletBalance']       as num?)?.toDouble(),
    );
  }
}