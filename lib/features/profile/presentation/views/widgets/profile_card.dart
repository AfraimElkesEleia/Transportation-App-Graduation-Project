import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';

/// Profile hero card displaying avatar, name, email, premium badge, and trip stats.
class ProfileCard extends StatelessWidget {
  /// The user's full name displayed on the card.
  final String fullName;

  /// The user's email displayed below the name.
  final String email;


  const ProfileCard({
    super.key,
    required this.fullName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            ColorsManager.profileGradientStart,
            ColorsManager.profileGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 40),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          email,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 6),
                        const Chip(
                          label: Text('Premium Member'),
                          backgroundColor: Colors.cyan,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('Total Trips', '12'),
              _buildStatItem('Distance Traveled', '2,450 km'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
