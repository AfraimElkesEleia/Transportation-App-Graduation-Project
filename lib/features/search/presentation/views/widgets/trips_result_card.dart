import 'package:flutter/material.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';
import 'package:transportation_app/features/search/domain/entities/floor_group.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/trip_expandable_part.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';

class TripResultCard extends StatelessWidget {
  final TripResultEntity trip;
  final void Function(TripResultEntity, CoachClassEntity)? onBookOverride;

  const TripResultCard({super.key, required this.trip, this.onBookOverride});

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

  String _fmt(DateTime? dt, {String am = 'AM', String pm = 'PM'}) {
    if (dt == null) return '--:--';
    final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final period = dt.hour >= 12 ? pm : am;
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
          Builder(
            builder: (context) {
              final loc = AppLocalizations.of(context)!;
              return _TimesRow(
                trip: trip,
                fmt: (dt) => _fmt(dt, am: loc.amLabel, pm: loc.pmLabel),
                isNextDay: _isNextDay,
              );
            },
          ),

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
              (group) => _FloorGroupTile(
                floor: group,
                onBook: (c) {
                  if (onBookOverride != null) {
                    onBookOverride!(trip, c);
                  } else {
                    context.pushNamed(
                      AppRoutes.resultScreen,
                      arguments: {"coachClass": c, "trip": trip},
                    );
                  }
                },
              ),
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
                context.isArabic
                    ? (trip.agencyNameAr ?? trip.agencyName)
                    : trip.agencyName,
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
            Text(
              AppLocalizations.of(context)!.from,
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
            Text(
              '${AppLocalizations.of(context)!.egp} ${trip.lowestPrice.toStringAsFixed(0)}',
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
            Builder(
              builder: (context) {
                final originStation = context.isArabic
                    ? (trip.originStationNameAr ?? trip.originStationName)
                    : trip.originStationName;
                final originGov = context.isArabic
                    ? (trip.originGovernorateAr ?? trip.originGovernorate)
                    : trip.originGovernorate;
                final originText = originStation.isNotEmpty
                    ? originStation.toLocalizedStation(context)
                    : originGov.toLocalizedGov(context).toUpperCase();
                return Text(
                  originText,
                  style: const TextStyle(
                    color: ColorsManager.textMuted,
                    fontSize: 11,
                  ),
                );
              },
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
                Text(
                  trip.hasRouteStops
                      ? AppLocalizations.of(
                          context,
                        )!.stopsCount('${trip.safeRouteStops.length}')
                      : AppLocalizations.of(context)!.directTrip,
                  style: const TextStyle(
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
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            Row(
              children: [
                Builder(
                  builder: (context) {
                    final destStation = context.isArabic
                        ? (trip.destinationStationNameAr ??
                              trip.destinationStationName)
                        : trip.destinationStationName;
                    final destGov = context.isArabic
                        ? (trip.destinationGovernorateAr ??
                              trip.destinationGovernorate)
                        : trip.destinationGovernorate;
                    final destText = destStation.isNotEmpty
                        ? destStation.toLocalizedStation(context)
                        : destGov.toLocalizedGov(context).toUpperCase();
                    return Text(
                      destText,
                      style: const TextStyle(
                        color: ColorsManager.textMuted,
                        fontSize: 11,
                      ),
                    );
                  },
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
    final loc = AppLocalizations.of(context)!;
    final isAr = context.isArabic;

    // Pick the best display name for the class group
    final displayName =
        isAr &&
            floor.classes.isNotEmpty &&
            floor.classes.first.classNameAr != null &&
            floor.classes.first.classNameAr!.isNotEmpty
        ? floor.classes.first.classNameAr!
        : floor.groupName;

    // Localized floor badge
    final floorBadge = floor.floorNumber != null
        ? loc.floorLabel('${floor.floorNumber}')
        : loc.standardClass;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColorsManager.surfaceChip.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorsManager.borderSubtle.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Class Name / Floor Badge & Book Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        floorBadge,
                        style: const TextStyle(
                          color: ColorsManager.accentCyan,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Book button
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
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      elevation: 0,
                    ),
                    child: Text(
                      floor.hasSeats ? loc.book : loc.fullSeats,
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
            const SizedBox(height: 10),
            const Divider(color: ColorsManager.borderSubtle, height: 1),
            const SizedBox(height: 10),
            // Row 2: Seats Count & Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Seats Count with Seat Icon
                Row(
                  children: [
                    Icon(
                      Icons.event_seat_outlined,
                      size: 16,
                      color: floor.totalSeats < 5
                          ? Colors.orangeAccent
                          : Colors.white38,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      loc.seatsCount('${floor.totalSeats}'),
                      style: TextStyle(
                        color: floor.totalSeats < 5
                            ? Colors.orangeAccent
                            : Colors.white38,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                // Lowest Price
                Text(
                  '${loc.egp} ${floor.lowestPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: ColorsManager.accentCyan,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
