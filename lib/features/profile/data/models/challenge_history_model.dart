import 'package:transportation_app/features/profile/domain/entities/challenge_history.dart';

class ChallengeHistoryModel extends ChallengeHistory {
  const ChallengeHistoryModel({
    required super.challengeId,
    required super.title,
    required super.description,
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
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      frequency: json['frequency'] ?? 'OneTime',
      currentProgress: json['currentProgress'] ?? 0,
      goalValue: json['goalValue'] ?? 1,
      rewardPoints: json['rewardPoints'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
