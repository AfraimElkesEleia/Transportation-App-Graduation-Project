import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';

/// Top bar for the seat selection screen.
///
/// Displays: ← back button | route label (From → To) | agency • class
class SeatAppBar extends StatelessWidget {
  final TripResultEntity trip;
  final CoachClassEntity coachClass;

  const SeatAppBar({super.key, required this.trip, required this.coachClass});

  String get _routeLabel {
    final from = trip.originGovernorate;
    final to = trip.destinationGovernorate;
    return '$from → $to';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // ── Back button ──
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: ColorsManager.seatContainerBg,
                borderRadius: BorderRadius.circular(21),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          // ── Title ──
          Expanded(
            child: Column(
              children: [
                Text(
                  _routeLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${trip.agencyName} • ${coachClass.groupName}',
                  style: const TextStyle(
                    color: ColorsManager.textMuted,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // ── Spacer to balance back button ──
          const SizedBox(width: 42),
        ],
      ),
    );
  }
}
