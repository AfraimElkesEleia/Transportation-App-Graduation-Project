import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';

class ChallengeModel extends ChallengeEntity {
  const ChallengeModel({
    required super.challengeId,
    required super.title,
    super.titleAr,
    super.description,
    super.descriptionAr,
    required super.type,
    required super.currentProgress,
    required super.goalValue,
    required super.rewardPoints,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      challengeId: json['challengeId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      titleAr: json['titleAr'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['descriptionAr'] as String?,
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
    super.preferredLanguage,
    super.profilePictureUrl,
    super.totalTrips,
    super.totalDistanceKm,
    super.walletBalance,
    super.loyaltyPointsBalance,
    super.expiringPointsAmount,
    super.nextExpiryDate,
    super.activeChallenges,
    super.idType,
    super.idNumber,
    super.hasSetIdentityDetails = false,
  });

  static int? _parseIdType(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      final clean = value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
      if (clean == 'nationalid' || clean == '1') return 1;
      if (clean == 'passport' || clean == '2') return 2;
      return int.tryParse(value);
    }
    return null;
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['userId'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      familyName: json['familyName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      gender: json['gender'] as String? ?? '',
      countryCode: json['countryCode'] as String? ?? '',
      countryName: json['countryName'] as String? ?? '',
      preferredLanguage: json['preferredLanguage'] as String?,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      totalTrips: json['totalTripsCount'] as int?,
      totalDistanceKm: (json['totalDistanceTraveled'] as num?)?.toDouble(),
      walletBalance: (json['walletBalance'] as num?)?.toDouble(),
      loyaltyPointsBalance: json['loyaltyPointsBalance'] as int?,
      expiringPointsAmount: json['expiringPointsAmount'] as int?,
      nextExpiryDate: json['nextExpiryDate'] as String?,
      activeChallenges: (json['activeChallenges'] as List<dynamic>?)
          ?.map((e) => ChallengeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      idType: _parseIdType(json['idType']),
      idNumber: json['idNumber'] as String?,
      hasSetIdentityDetails: json['hasSetIdentityDetails'] as bool? ?? false,
    );
  }
}
