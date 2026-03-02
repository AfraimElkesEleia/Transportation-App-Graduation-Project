import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';

/// Summary card showing an icon, title, and value (e.g. "Available: 3").
///
/// Used in the resell tickets screen header.
class ResaleSummaryCard extends StatelessWidget {
  /// Leading icon for the card.
  final IconData icon;

  /// Summary title (e.g. "Available").
  final String title;

  /// Summary value (e.g. "3", "655 EGP").
  final String value;

  const ResaleSummaryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.resellCardBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.1),
            child: Icon(icon, color: ColorsManager.accentCyan, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
