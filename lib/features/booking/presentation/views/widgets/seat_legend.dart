import 'package:flutter/material.dart';
import 'package:transportation_app/features/booking/domain/entities/seat_map.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/seat_circle.dart';

/// A row of legend indicators: Available • Selected • Taken.
class SeatLegend extends StatelessWidget {
  const SeatLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(status: SeatStatus.available, label: 'Available'),
        SizedBox(width: 20),
        _LegendItem(status: SeatStatus.pending, label: 'Selected'),
        SizedBox(width: 20),
        _LegendItem(status: SeatStatus.booked, label: 'Taken'),
      ],
    );
  }
}

/// A single legend entry: small seat circle + label text.
class _LegendItem extends StatelessWidget {
  final SeatStatus status;
  final String     label;

  const _LegendItem({required this.status, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SeatCircle(status: status, size: 18, showLabel: false),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color:    status == SeatStatus.booked
                ? Colors.white38
                : Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
