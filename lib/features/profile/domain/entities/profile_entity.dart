import 'package:equatable/equatable.dart';

class ChallengeEntity extends Equatable {
  final int challengeId;
  final String title;
  final String? titleAr;
  final String? description;
  final String? descriptionAr;
  final int type;
  final int currentProgress;
  final int goalValue;
  final int rewardPoints;

  const ChallengeEntity({
    required this.challengeId,
    required this.title,
    this.titleAr,
    this.description,
    this.descriptionAr,
    required this.type,
    required this.currentProgress,
    required this.goalValue,
    required this.rewardPoints,
  });

  @override
  List<Object?> get props => [
    challengeId,
    title,
    titleAr,
    description,
    descriptionAr,
    type,
    currentProgress,
    goalValue,
    rewardPoints,
  ];
}

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
  final String? preferredLanguage;
  final String? profilePictureUrl;
  final int? totalTrips;
  final double? totalDistanceKm;
  final double? walletBalance;
  final int? loyaltyPointsBalance;
  final int? expiringPointsAmount;
  final String? nextExpiryDate;
  final List<ChallengeEntity>? activeChallenges;
  final int? idType;      // 1 = National ID, 2 = Passport
  final String? idNumber;
  final bool hasSetIdentityDetails;
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
    this.preferredLanguage,
    this.profilePictureUrl,
    this.totalTrips,
    this.totalDistanceKm,
    this.walletBalance,
    this.loyaltyPointsBalance,
    this.expiringPointsAmount,
    this.nextExpiryDate,
    this.activeChallenges,
    this.idType,
    this.idNumber,
    this.hasSetIdentityDetails = false,
  });

  ProfileEntity copyWith({
    String? firstName,
    String? lastName,
    String? familyName,
    String? email,
    String? phoneNumber,
    String? preferredLanguage,
    String? profilePictureUrl,
    int? totalTrips,
    double? totalDistanceKm,
    double? walletBalance,
    int? loyaltyPointsBalance,
    int? expiringPointsAmount,
    String? nextExpiryDate,
    List<ChallengeEntity>? activeChallenges,
    int? idType,
    String? idNumber,
    bool? hasSetIdentityDetails,
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
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      totalTrips: totalTrips ?? this.totalTrips,
      totalDistanceKm: totalDistanceKm ?? this.totalDistanceKm,
      walletBalance: walletBalance ?? this.walletBalance,
      loyaltyPointsBalance: loyaltyPointsBalance ?? this.loyaltyPointsBalance,
      expiringPointsAmount: expiringPointsAmount ?? this.expiringPointsAmount,
      nextExpiryDate: nextExpiryDate ?? this.nextExpiryDate,
      activeChallenges: activeChallenges ?? this.activeChallenges,
      idType: idType ?? this.idType,
      idNumber: idNumber ?? this.idNumber,
      hasSetIdentityDetails: hasSetIdentityDetails ?? this.hasSetIdentityDetails,
    );
  }

  String get fullName =>
      '$firstName $lastName $familyName'.replaceAll(RegExp(r'\s+'), ' ').trim();

  String get initials {
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '${firstName[0]}${lastName[0]}'.toUpperCase();
    }
    return firstName.isNotEmpty ? firstName[0].toUpperCase() : '?';
  }

  @override
  List<Object?> get props => [userId, email, preferredLanguage];
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
