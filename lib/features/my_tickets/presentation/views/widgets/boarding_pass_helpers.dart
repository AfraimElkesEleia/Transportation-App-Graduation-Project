import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatBoardingPassTime(DateTime dt) => DateFormat('hh:mm a').format(dt);

String formatBoardingPassDate(DateTime dt) =>
    DateFormat('dd MMM yyyy').format(dt);

String boardingPassLocationCode(String city) {
  if (city.length < 3) return city.toUpperCase();
  return city.substring(0, 3).toUpperCase();
}

String boardingPassDuration(DateTime from, DateTime to) {
  final diff = to.difference(from);
  final h = diff.inHours;
  final m = diff.inMinutes % 60;
  return '${h}h ${m}m';
}

class BoardingPassDashedDivider extends StatelessWidget {
  const BoardingPassDashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        const dashWidth = 6.0;
        const dashSpace = 4.0;
        final count = (constraints.maxWidth / (dashWidth + dashSpace)).floor();

        return Row(
          children: List.generate(
            count,
            (_) => Container(
              width: dashWidth,
              height: 1,
              margin: const EdgeInsets.only(right: dashSpace),
              color: Colors.white12,
            ),
          ),
        );
      },
    );
  }
}

class BoardingPassInfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const BoardingPassInfoChip({
    super.key,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 9,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
