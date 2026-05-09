import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';

/// Shows departure time, duration badge, and arrival time in a horizontal row.
class TripTimesRow extends StatelessWidget {
  final TripResultEntity trip;

  const TripTimesRow({super.key, required this.trip});

  String _fmt(DateTime? dt) {
    if (dt == null) return '--:--';
    return DateFormat.jm().format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Departure ──
          _TimeColumn(
            time: _fmt(trip.departureTime),
            label: trip.originStationName.isNotEmpty
                ? trip.originStationName
                : trip.originGovernorate,
            alignment: CrossAxisAlignment.start,
          ),

          // ── Duration badge ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2E4A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF1E3A52)),
            ),
            child: Text(
              trip.durationFormatted,
              style: const TextStyle(
                color: ColorsManager.accentCyan,
                fontSize: 12,
              ),
            ),
          ),

          // ── Arrival ──
          _TimeColumn(
            time: _fmt(trip.arrivalTime),
            label: trip.destinationStationName.isNotEmpty
                ? trip.destinationStationName
                : trip.destinationGovernorate,
            alignment: CrossAxisAlignment.end,
          ),
        ],
      ),
    );
  }
}

/// A single time column (time + station label).
class _TimeColumn extends StatelessWidget {
  final String time;
  final String label;
  final CrossAxisAlignment alignment;

  const _TimeColumn({
    required this.time,
    required this.label,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: ColorsManager.textMuted, fontSize: 11),
        ),
      ],
    );
  }
}
