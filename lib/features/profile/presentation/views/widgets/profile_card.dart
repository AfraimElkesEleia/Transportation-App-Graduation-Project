import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';

class ProfileCard extends StatelessWidget {
  final String fullName;
  final String email;
  final String? profilePictureUrl;
  final int? totalTrips;
  final double? totalDistanceKm;
  final VoidCallback? onEditTap;

  const ProfileCard({
    super.key,
    required this.fullName,
    required this.email,
    this.profilePictureUrl,
    this.totalTrips,
    this.totalDistanceKm,
    this.onEditTap,
  });

  String get _initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

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
                  // ── Avatar ───────────────────────────────
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white24,
                    backgroundImage: profilePictureUrl != null
                        ? NetworkImage(profilePictureUrl!)
                        : null,
                    child: profilePictureUrl == null
                        ? Text(
                            _initials,
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),

                  // ── Name / email / badge ─────────────────
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

              // ── Edit button — top right ──────────────────
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onEditTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Edit',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Stats ────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('Total Trips', totalTrips?.toString() ?? '--'),
              _buildStatItem(
                'Distance Traveled',
                totalDistanceKm != null
                    ? '${totalDistanceKm!.toStringAsFixed(0)} km'
                    : '--',
              ),
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
