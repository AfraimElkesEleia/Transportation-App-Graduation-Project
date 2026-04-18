import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';
import 'package:transportation_app/features/search/domain/entities/floor_group.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/trip_expandable_part.dart';

class TripResultCard extends StatelessWidget {
  final TripResultEntity trip;
  const TripResultCard({super.key, required this.trip});

  Color _agencyColor(String name) {
    final l = name.toLowerCase();
    if (l.contains('gobus')) return ColorsManager.agencyGoBus;
    if (l.contains('blue')) return ColorsManager.agencyBlueBus;
    if (l.contains('railway') || l.contains('enr') || l.contains('train')) {
      return ColorsManager.agencyRailway;
    }
    if (l.contains('horus')) return ColorsManager.agencyHorus;
    return ColorsManager.agencyDefault;
  }

  IconData _agencyIcon(String name) {
    final l = name.toLowerCase();
    if (l.contains('railway') || l.contains('enr') || l.contains('train')) {
      return Icons.train;
    }
    return Icons.directions_bus;
  }

  String _fmt(DateTime? dt) {
    if (dt == null) return '--:--';
    final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${hour.toString().padLeft(2, '0')}:$minute\n $period';
  }

  bool _isNextDay(DateTime dep, DateTime? arr) {
    if (arr == null) return false;
    return arr.day != dep.day || arr.month != dep.month;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorsManager.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Agency row
          _AgencyRow(
            trip: trip,
            agencyColor: _agencyColor(trip.agencyName),
            agencyIcon: _agencyIcon(trip.agencyName),
          ),
          const SizedBox(height: 20),

          // ── Times row
          _TimesRow(trip: trip, fmt: _fmt, isNextDay: _isNextDay),

          // ── Available classes
          // if (trip.availableClasses.isNotEmpty) ...[
          //   const SizedBox(height: 16),
          //   const Divider(color: ColorsManager.borderSubtle),
          //   const SizedBox(height: 8),
          //   ...trip.floorGroups.map(
          //     (group) => _ClassRow(cls: group, trip: trip),
          //   ),
          // ],
          if (trip.floorGroups.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(color: ColorsManager.borderSubtle),
            const SizedBox(height: 8),
            ...trip.floorGroups.map(
              (group) => _FloorGroupTile(floor: group, onBook: (c) {}),
            ),
          ],
          if (trip.hasRouteStops) ...[
            const SizedBox(height: 8),
            TripExpandableSection(
              key: ValueKey('expand_${trip.tripOccurrenceId}'),
              routeStops: trip.safeRouteStops,
            ),
          ],
        ],
      ),
    );
  }
}

/// Agency name, icon and price badge.
class _AgencyRow extends StatelessWidget {
  final TripResultEntity trip;
  final Color agencyColor;
  final IconData agencyIcon;

  const _AgencyRow({
    required this.trip,
    required this.agencyColor,
    required this.agencyIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: agencyColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(agencyIcon, color: Colors.white, size: 26),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trip.agencyName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                trip.durationFormatted,
                style: const TextStyle(
                  color: ColorsManager.textMuted,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'from',
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
            Text(
              'EGP ${trip.lowestPrice.toStringAsFixed(0)}',
              style: const TextStyle(
                color: ColorsManager.accentCyan,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Departure / arrival times with route line.
class _TimesRow extends StatelessWidget {
  final TripResultEntity trip;
  final String Function(DateTime?) fmt;
  final bool Function(DateTime, DateTime?) isNextDay;

  const _TimesRow({
    required this.trip,
    required this.fmt,
    required this.isNextDay,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Departure
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fmt(trip.departureTime),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            Text(
              trip.originStationName.isNotEmpty
                  ? trip.originStationName
                  : trip.originGovernorate.toUpperCase(),
              style: const TextStyle(
                color: ColorsManager.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),

        // Line
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Text(
                  trip.durationFormatted,
                  style: const TextStyle(
                    color: ColorsManager.textMuted,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorsManager.accentCyan,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1.5,
                        color: ColorsManager.accentCyan,
                      ),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: ColorsManager.accentCyan,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Direct',
                  style: TextStyle(
                    color: ColorsManager.textMuted,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),

        // Arrival
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              fmt(trip.arrivalTime),
              style: TextStyle(
                color: trip.arrivalTime == null
                    ? Colors.white.withOpacity(0.2)
                    : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            Row(
              children: [
                Text(
                  trip.destinationStationName.isNotEmpty
                      ? trip.destinationStationName
                      : trip.destinationGovernorate.toUpperCase(),
                  style: const TextStyle(
                    color: ColorsManager.textMuted,
                    fontSize: 11,
                  ),
                ),
                if (isNextDay(trip.departureTime, trip.arrivalTime)) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: ColorsManager.badgeBg,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '+1D',
                      style: TextStyle(
                        color: ColorsManager.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }
}
class _FloorGroupTile extends StatelessWidget {
  final FloorGroup floor;
  final void Function(CoachClassEntity) onBook;

  const _FloorGroupTile({required this.floor, required this.onBook});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          // ── Class name + floor label ─────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // "Horus - Prestige"
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: ColorsManager.surfaceChip,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      floor.groupName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                    if (floor.floorNumber != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        floor.label,
                        style: const TextStyle(
                          color: ColorsManager.accentCyan,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),

          // ── Total seats (combined Single + Double) ───
          Text(
            '${floor.totalSeats} seats',
            style: TextStyle(
              color: floor.totalSeats < 5
                  ? Colors.orangeAccent
                  : Colors.white38,
              fontSize: 12,
            ),
          ),
          const Spacer(),

          // ── Price ────────────────────────────────────
          Text(
            'EGP ${floor.lowestPrice.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 12),

          // ── Book button ──────────────────────────────
          SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: floor.hasSeats
                  ? () {
                      final cls = floor.classes
                          .where((c) => c.hasSeats)
                          .reduce((a, b) => a.price <= b.price ? a : b);
                      onBook(cls);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: floor.hasSeats
                    ? ColorsManager.buttonBlue
                    : ColorsManager.surfaceMid,
                disabledBackgroundColor: ColorsManager.surfaceMid,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                elevation: 0,
              ),
              child: Text(
                floor.hasSeats ? 'Book' : 'Full',
                style: TextStyle(
                  color: floor.hasSeats ? Colors.white : Colors.white38,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
