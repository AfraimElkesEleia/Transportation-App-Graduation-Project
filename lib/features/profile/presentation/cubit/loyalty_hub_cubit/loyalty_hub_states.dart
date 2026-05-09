import 'package:transportation_app/features/profile/domain/entities/challenge_history.dart';
import 'package:transportation_app/features/profile/domain/entities/point_transaction.dart';

abstract class LoyaltyHubState {}

class LoyaltyHubInitial extends LoyaltyHubState {}

class LoyaltyHubLoading extends LoyaltyHubState {}

class LoyaltyHubLoaded extends LoyaltyHubState {
  final List<ChallengeHistory> challenges;
  final List<PointTransaction> points;
  final bool hasMoreChallenges;
  final bool hasMorePoints;
  final bool showCompleted;
  final bool isLoadingMoreChallenges;
  final bool isLoadingMorePoints;

  LoyaltyHubLoaded({
    required this.challenges,
    required this.points,
    required this.hasMoreChallenges,
    required this.hasMorePoints,
    required this.showCompleted,
    this.isLoadingMoreChallenges = false,
    this.isLoadingMorePoints = false,
  });

  LoyaltyHubLoaded copyWith({
    List<ChallengeHistory>? challenges,
    List<PointTransaction>? points,
    bool? hasMoreChallenges,
    bool? hasMorePoints,
    bool? showCompleted,
    bool? isLoadingMoreChallenges,
    bool? isLoadingMorePoints,
  }) {
    return LoyaltyHubLoaded(
      challenges: challenges ?? this.challenges,
      points: points ?? this.points,
      hasMoreChallenges: hasMoreChallenges ?? this.hasMoreChallenges,
      hasMorePoints: hasMorePoints ?? this.hasMorePoints,
      showCompleted: showCompleted ?? this.showCompleted,
      isLoadingMoreChallenges: isLoadingMoreChallenges ?? this.isLoadingMoreChallenges,
      isLoadingMorePoints: isLoadingMorePoints ?? this.isLoadingMorePoints,
    );
  }
}

class LoyaltyHubError extends LoyaltyHubState {
  final String message;

  LoyaltyHubError(this.message);
}
