class ChallengeHistory {
  final int challengeId;
  final String title;
  final String description;
  final String type;
  final String frequency;   // "OneTime" | "Monthly"
  final int currentProgress;
  final int goalValue;
  final int rewardPoints;
  final bool isCompleted;

  const ChallengeHistory({
    required this.challengeId,
    required this.title,
    required this.description,
    required this.type,
    required this.frequency,
    required this.currentProgress,
    required this.goalValue,
    required this.rewardPoints,
    required this.isCompleted,
  });

  bool get isMonthly => frequency == 'Monthly';
  double get progressRatio =>
      goalValue > 0 ? (currentProgress / goalValue).clamp(0.0, 1.0) : 0;
}
