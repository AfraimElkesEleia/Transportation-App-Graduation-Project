import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';

/// Individual statistic box used in the marketplace header row.
///
/// Displays an [icon], a [value], and a [label] inside a rounded container.
class MarketplaceStatBox extends StatelessWidget {
  /// The icon displayed at the top of the box.
  final IconData icon;

  /// The stat value (e.g. "5", "15%").
  final String value;

  /// The stat label (e.g. "Available", "Avg. Discount").
  final String label;

  /// Accent color for the icon.
  final Color color;

  const MarketplaceStatBox({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: ColorsManager.marketplaceCardBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
