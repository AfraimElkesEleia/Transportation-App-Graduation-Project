import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';

/// Promotional banner encouraging users to browse the marketplace.
class ResaleExploreBanner extends StatelessWidget {
  /// Callback when the "Explore" button is tapped.
  final VoidCallback? onExploreTap;

  const ResaleExploreBanner({super.key, this.onExploreTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.resellSurfaceTeal.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.teal.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white10,
            child: Icon(Icons.star_border, color: ColorsManager.successGreen),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Browse Marketplace",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Find tickets from other travelers",
                  style: TextStyle(
                    color: ColorsManager.successGreen,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onExploreTap,
            child: const Text(
              "Explore",
              style: TextStyle(
                color: ColorsManager.successGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
