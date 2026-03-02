import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';

/// A card displaying a ticket available for resale with route, schedule,
/// seat info, estimated value, and a sell button.
class ResaleTicketCard extends StatelessWidget {
  /// Route label (e.g. "Cairo → Alexandria").
  final String fromTo;

  /// Departure date.
  final String date;

  /// Departure time.
  final String time;

  /// Seat number.
  final String seat;

  /// Travel class name.
  final String className;

  /// Estimated resale value.
  final String estValue;

  /// Original ticket price.
  final String originalPrice;

  /// Days remaining label.
  final String daysLeft;

  const ResaleTicketCard({
    super.key,
    required this.fromTo,
    required this.date,
    required this.time,
    required this.seat,
    required this.className,
    required this.estValue,
    required this.originalPrice,
    required this.daysLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.resellCardBg.withOpacity(0.4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: ColorsManager.accentCyan.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          // Route header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.train, color: ColorsManager.accentCyan),
                  const SizedBox(width: 8),
                  Text(
                    fromTo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.cyan.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  daysLeft,
                  style: const TextStyle(
                    color: ColorsManager.accentCyan,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Date & time
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.white60),
              const SizedBox(width: 5),
              Text(
                date,
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
              const SizedBox(width: 15),
              const Icon(Icons.access_time, size: 14, color: Colors.white60),
              const SizedBox(width: 5),
              Text(
                time,
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Info & sell
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoDetail("Seat", seat),
              _infoDetail("Class", className),
              _infoDetail("Est. Value", estValue, isPrice: true),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Original: $originalPrice",
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.sell_outlined, size: 16),
                    label: const Text("Sell Ticket"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.successGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoDetail(String label, String value, {bool isPrice = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
        Text(
          value,
          style: TextStyle(
            color: isPrice ? ColorsManager.successGreen : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isPrice ? 16 : 14,
          ),
        ),
      ],
    );
  }
}
