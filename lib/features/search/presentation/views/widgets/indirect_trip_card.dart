import 'package:flutter/material.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/search/domain/entities/indirect_trips_enitity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';

class IndirectTripCard extends StatelessWidget {
  final IndirectTripEntity trip;
  const IndirectTripCard({super.key, required this.trip});

  String _fmt(DateTime? dt) {
    if (dt == null) return '--:--';
    final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorsManager.accentCyan.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Total summary
          _TripSummaryHeader(trip: trip),
          const Divider(height: 1, color: ColorsManager.borderSubtle),

          // ── Leg 1
          _LegRow(label: 'LEG 1', leg: trip.firstLeg, fmt: _fmt),

          // ── Layover badge
          _LayoverBadge(trip: trip),

          // ── Leg 2
          _LegRow(label: 'LEG 2', leg: trip.secondLeg, fmt: _fmt),

          // ── Book button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.resultScreen,
                  arguments: {'indirectTrip': trip},
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.buttonBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Book Route',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Top summary with route icon, stop count, and price.
class _TripSummaryHeader extends StatelessWidget {
  final IndirectTripEntity trip;
  const _TripSummaryHeader({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(
            Icons.alt_route,
            color: ColorsManager.accentCyan,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            '1 Stop • ${trip.totalDurationFormatted}',
            style: const TextStyle(
              color: ColorsManager.accentCyan,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'from',
                style: TextStyle(color: Colors.white38, fontSize: 11),
              ),
              Text(
                'EGP ${trip.totalStartingPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: ColorsManager.accentCyan,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Layover badge between two legs.
class _LayoverBadge extends StatelessWidget {
  final IndirectTripEntity trip;
  const _LayoverBadge({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: ColorsManager.surfaceChip,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ColorsManager.borderSubtle),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time, color: Colors.white38, size: 14),
            const SizedBox(width: 6),
            Text(
              trip.layoverFormatted,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(width: 6),
            Text(
              'at ${trip.firstLeg.destinationStationName.isNotEmpty ? trip.firstLeg.destinationStationName : trip.firstLeg.destinationGovernorate}',
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single leg row showing departure → arrival.
class _LegRow extends StatelessWidget {
  final String label;
  final TripResultEntity leg;
  final String Function(DateTime?) fmt;

  const _LegRow({required this.label, required this.leg, required this.fmt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Leg label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: ColorsManager.surfaceChip,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Departure time
          Text(
            fmt(leg.departureTime),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 6),

          // Origin
          Expanded(
            child: Text(
              leg.originStationName.isNotEmpty
                  ? leg.originStationName
                  : leg.originGovernorate,
              style: const TextStyle(
                color: ColorsManager.textMuted,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const Icon(
            Icons.arrow_forward,
            color: ColorsManager.textMuted,
            size: 14,
          ),
          const SizedBox(width: 6),

          // Arrival time
          Text(
            fmt(leg.arrivalTime),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 6),

          // Destination
          Expanded(
            child: Text(
              leg.destinationStationName.isNotEmpty
                  ? leg.destinationStationName
                  : leg.destinationGovernorate,
              style: const TextStyle(
                color: ColorsManager.textMuted,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
