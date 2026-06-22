import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/features/booking/domain/entities/seat_map.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/seat_circle.dart';

/// A row of legend indicators: Available • Selected • Taken.
class SeatLegend extends StatelessWidget {
  const SeatLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(status: SeatStatus.available, label: l10n.seatLegendAvailable),
        const SizedBox(width: 20),
        _LegendItem(status: SeatStatus.pending, label: l10n.seatLegendSelected),
        const SizedBox(width: 20),
        _LegendItem(status: SeatStatus.booked, label: l10n.seatLegendTaken),
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
