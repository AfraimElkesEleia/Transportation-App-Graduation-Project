import 'package:transportation_app/features/profile/domain/entities/challenge_history.dart';

class ChallengeHistoryModel extends ChallengeHistory {
  const ChallengeHistoryModel({
    required super.challengeId,
    required super.title,
    super.titleAr,
    required super.description,
    super.descriptionAr,
    required super.type,
    required super.frequency,
    required super.currentProgress,
    required super.goalValue,
    required super.rewardPoints,
    required super.isCompleted,
  });

  factory ChallengeHistoryModel.fromJson(Map<String, dynamic> json) {
    return ChallengeHistoryModel(
      challengeId: json['challengeId'] ?? 0,
      title: json['title'] ?? '',
      titleAr: json['titleAr'],
      description: json['description'] ?? '',
      descriptionAr: json['descriptionAr'],
      type: json['type'] ?? '',
      frequency: json['frequency'] ?? 'OneTime',
      currentProgress: json['currentProgress'] ?? 0,
      goalValue: json['goalValue'] ?? 1,
      rewardPoints: json['rewardPoints'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
