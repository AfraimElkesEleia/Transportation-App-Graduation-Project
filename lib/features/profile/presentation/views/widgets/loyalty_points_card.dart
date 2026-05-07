import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';

class LoyaltyPointsCard extends StatefulWidget {
  final ProfileEntity? profile;
  
  const LoyaltyPointsCard({super.key, this.profile});

  @override
  State<LoyaltyPointsCard> createState() => _LoyaltyPointsCardState();
}

class _LoyaltyPointsCardState extends State<LoyaltyPointsCard> {
  bool _showChallenges = false;

  @override
  Widget build(BuildContext context) {
    final points = widget.profile?.loyaltyPointsBalance;
    final expiring = widget.profile?.expiringPointsAmount;
    final expiryDate = widget.profile?.nextExpiryDate;
    final expiringText = expiring != null && expiring > 0
        ? '$expiring pts expiring${expiryDate != null ? ' by $expiryDate' : ''}'
        : 'No expiring points right now';
    
    final challenges = widget.profile?.activeChallenges ?? [];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D2B5E), Color(0xFF1A4A8A)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFFD700),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Loyalty Points',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                points?.toString() ?? '--',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  'pts',
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            expiringText,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 10),
          const Text(
            'Points are pending until departure and expire 4 months after departure.',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          
          if (challenges.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(color: Colors.white24),
            InkWell(
              onTap: () {
                setState(() {
                  _showChallenges = !_showChallenges;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.flag_rounded, color: Color(0xFFFFD700), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Active Challenges',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      _showChallenges ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                children: challenges.map((challenge) => _buildChallengeChartCard(challenge)).toList(),
              ),
              crossFadeState: _showChallenges ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChallengeChartCard(ChallengeEntity challenge) {
    final progress = challenge.currentProgress / challenge.goalValue;
    final percent = (progress * 100).clamp(0, 100).toDouble();

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 22,
                    startDegreeOffset: -90,
                    sections: [
                      PieChartSectionData(
                        color: ColorsManager.accentCyan,
                        value: percent,
                        showTitle: false,
                        radius: 8,
                      ),
                      PieChartSectionData(
                        color: Colors.white.withOpacity(0.1),
                        value: 100 - percent,
                        showTitle: false,
                        radius: 8,
                      ),
                    ],
                  ),
                ),
                Text(
                  '${percent.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${challenge.currentProgress} / ${challenge.goalValue} trips',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  'Reward: ${challenge.rewardPoints} points',
                  style: const TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
