import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/search/domain/entities/indirect_trips_enitity.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';

class IndirectTripCard extends StatefulWidget {
  final IndirectTripEntity trip;
  final SearchParams activeParams;
  
  const IndirectTripCard({
    super.key, 
    required this.trip,
    required this.activeParams,
  });

  @override
  State<IndirectTripCard> createState() => _IndirectTripCardState();
}

class _IndirectTripCardState extends State<IndirectTripCard> {
  late DateTime _dateLeg1;
  late DateTime _dateLeg2;

  @override
  void initState() {
    super.initState();
    // Default to the suggested dates from the API, or today if missing.
    _dateLeg1 = widget.trip.firstLeg.departureTime;
    _dateLeg2 = widget.trip.secondLeg.departureTime;

    // Ensure Leg 2 is >= Leg 1
    if (_dateLeg2.isBefore(_dateLeg1)) {
      _dateLeg2 = _dateLeg1;
    }
  }

  Future<void> _pickDate(int leg) async {
    final initialDate = leg == 1 ? _dateLeg1 : _dateLeg2;
    // Leg 2 minimum date is Leg 1's date
    final firstDate = leg == 1 ? DateTime.now() : _dateLeg1;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(firstDate) ? firstDate : initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: ColorsManager.accentCyan,
              onPrimary: Colors.black,
              surface: ColorsManager.surfaceDark,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (leg == 1) {
          _dateLeg1 = picked;
          if (_dateLeg2.isBefore(_dateLeg1)) {
            _dateLeg2 = _dateLeg1;
          }
        } else {
          _dateLeg2 = picked;
        }
      });
    }
  }

  void _onBuildJourney() {
    // Navigate to the new Indirect Builder Wizard
    Navigator.pushNamed(
      context,
      AppRoutes.indirectBookingScreen,
      arguments: {
        'indirectTrip': widget.trip,
        'dateLeg1': _dateLeg1,
        'dateLeg2': _dateLeg2,
        'activeParams': widget.activeParams,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorsManager.accentCyan.withAlpha(38), // 0.15 * 255
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header (Stations Overview)
          _TripSummaryHeader(trip: widget.trip),
          const Divider(height: 1, color: ColorsManager.borderSubtle),

          // ── Leg 1
          _LegConfigRow(
            label: 'LEG 1',
            origin: widget.trip.firstLeg.originStationName.isNotEmpty
                ? widget.trip.firstLeg.originStationName
                : widget.trip.firstLeg.originGovernorate,
            destination: widget.trip.firstLeg.destinationStationName.isNotEmpty
                ? widget.trip.firstLeg.destinationStationName
                : widget.trip.firstLeg.destinationGovernorate,
            date: _dateLeg1,
            onDateTap: () => _pickDate(1),
          ),

          // ── Transfer badge
          _TransferBadge(trip: widget.trip),

          // ── Leg 2
          _LegConfigRow(
            label: 'LEG 2',
            origin: widget.trip.secondLeg.originStationName.isNotEmpty
                ? widget.trip.secondLeg.originStationName
                : widget.trip.secondLeg.originGovernorate,
            destination: widget.trip.secondLeg.destinationStationName.isNotEmpty
                ? widget.trip.secondLeg.destinationStationName
                : widget.trip.secondLeg.destinationGovernorate,
            date: _dateLeg2,
            onDateTap: () => _pickDate(2),
          ),

          // ── Build Journey button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _onBuildJourney,
                icon: const Icon(Icons.build, size: 18),
                label: const Text(
                  'Build Journey',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.accentCyan,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Top summary with route icon, showing Origin -> Transfer -> Destination
class _TripSummaryHeader extends StatelessWidget {
  final IndirectTripEntity trip;
  const _TripSummaryHeader({required this.trip});

  @override
  Widget build(BuildContext context) {
    final t1 = trip.firstLeg;
    final t2 = trip.secondLeg;
    final o = t1.originStationName.isNotEmpty ? t1.originStationName : t1.originGovernorate;
    final trans = t1.destinationStationName.isNotEmpty ? t1.destinationStationName : t1.destinationGovernorate;
    final d = t2.destinationStationName.isNotEmpty ? t2.destinationStationName : t2.destinationGovernorate;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(
            Icons.alt_route,
            color: ColorsManager.accentCyan,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Suggested Transfer Route',
                  style: TextStyle(
                    color: ColorsManager.accentCyan,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$o ➔ $trans ➔ $d',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Transfer badge between two legs.
class _TransferBadge extends StatelessWidget {
  final IndirectTripEntity trip;
  const _TransferBadge({required this.trip});

  @override
  Widget build(BuildContext context) {
    final trans = trip.firstLeg.destinationStationName.isNotEmpty 
        ? trip.firstLeg.destinationStationName 
        : trip.firstLeg.destinationGovernorate;

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
            const Icon(Icons.transfer_within_a_station, color: ColorsManager.textMuted, size: 16),
            const SizedBox(width: 6),
            Text(
              'Transfer at $trans',
              style: const TextStyle(color: ColorsManager.textMuted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single leg config row showing stations and a date picker.
class _LegConfigRow extends StatelessWidget {
  final String label;
  final String origin;
  final String destination;
  final DateTime date;
  final VoidCallback onDateTap;

  const _LegConfigRow({
    required this.label,
    required this.origin,
    required this.destination,
    required this.date,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: ColorsManager.surfaceChip,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: ColorsManager.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '$origin ➔ $destination',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: onDateTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: ColorsManager.seatContainerBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ColorsManager.borderSubtle),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: ColorsManager.accentCyan, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('EEE, MMM dd, yyyy').format(date),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const Spacer(),
                  const Icon(Icons.edit, color: ColorsManager.textMuted, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
