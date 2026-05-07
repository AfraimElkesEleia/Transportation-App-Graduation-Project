import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';

class ChallengeModel extends ChallengeEntity {
  const ChallengeModel({
    required super.challengeId,
    required super.title,
    required super.type,
    required super.currentProgress,
    required super.goalValue,
    required super.rewardPoints,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      challengeId: json['challengeId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      type: json['type'] as int? ?? 0,
      currentProgress: json['currentProgress'] as int? ?? 0,
      goalValue: json['goalValue'] as int? ?? 1,
      rewardPoints: json['rewardPoints'] as int? ?? 0,
    );
  }
}

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
    super.loyaltyPointsBalance,
    super.expiringPointsAmount,
    super.nextExpiryDate,
    super.activeChallenges,
  });
  static String? _buildImageUrl(String? path) {
  if (path == null || path.isEmpty) return null;
  if (path.startsWith('http')) return path;  // already full URL
  return 'http://rehlabussines-001-site1.anytempurl.com/$path';
}

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
      loyaltyPointsBalance: json['loyaltyPointsBalance'] as int?,
      expiringPointsAmount: json['expiringPointsAmount'] as int?,
      nextExpiryDate: json['nextExpiryDate'] as String?,
      activeChallenges: (json['activeChallenges'] as List<dynamic>?)
          ?.map((e) => ChallengeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}