import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';

/// Renders a date section label such as "Today (3)" or "11 May 2026 (2)".
class NotificationSectionHeader extends StatelessWidget {
  final String label;
  final int count;

  const NotificationSectionHeader({
    super.key,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Row(
        children: [
          Text(
            '$label ($count)',
            style: const TextStyle(
              color: ColorsManager.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(height: 1, color: ColorsManager.borderSubtle),
          ),
        ],
      ),
    );
  }
}
