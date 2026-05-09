import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/profile/domain/entities/challenge_history.dart';

class ChallengeCard extends StatelessWidget {
  final ChallengeHistory challenge;

  const ChallengeCard({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsManager.borderDim),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${challenge.isCompleted ? '✅' : '🎯'} ${challenge.title}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: challenge.isMonthly
                      ? const Color(0xFF007AFF).withValues(alpha: 0.15)
                      : const Color(0xFF40E0D0).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  challenge.isMonthly ? '🔄 Monthly' : 'OneTime',
                  style: TextStyle(
                    color: challenge.isMonthly ? const Color(0xFF007AFF) : const Color(0xFF40E0D0),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            challenge.description,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: challenge.progressRatio,
                    minHeight: 8,
                    backgroundColor: ColorsManager.borderDim,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      challenge.isCompleted ? ColorsManager.successGreen : const Color(0xFF2089FF),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${challenge.currentProgress} / ${challenge.goalValue}',
                style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '+${challenge.rewardPoints} pts',
            style: const TextStyle(
              color: Color(0xFFFFD700),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
