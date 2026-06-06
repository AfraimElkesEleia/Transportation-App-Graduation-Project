import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/booking/presentation/cubit/indirect_booking_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/indirect_booking_state.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_cubit.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/embedded_seat_selection.dart';
import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';
import 'package:transportation_app/features/search/domain/entities/indirect_trips_enitity.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/search_error_view.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/trips_result_card.dart';

class IndirectBookingScreen extends StatefulWidget {
  final IndirectTripEntity indirectTrip;
  final DateTime dateLeg1;
  final DateTime dateLeg2;
  final SearchParams activeParams;

  const IndirectBookingScreen({
    super.key,
    required this.indirectTrip,
    required this.dateLeg1,
    required this.dateLeg2,
    required this.activeParams,
  });

  @override
  State<IndirectBookingScreen> createState() => _IndirectBookingScreenState();
}

class _IndirectBookingScreenState extends State<IndirectBookingScreen> {
  @override
  void initState() {
    super.initState();
    // Fire the initial search
    context.read<IndirectBookingCubit>().searchLeg1(
      fromStationId: widget.indirectTrip.firstLeg.originStationId,
      toStationId: widget.indirectTrip.firstLeg.destinationStationId,
      fromDisplayName: widget.indirectTrip.firstLeg.originStationName.isNotEmpty
          ? widget.indirectTrip.firstLeg.originStationName
          : widget.indirectTrip.firstLeg.originGovernorate,
      toDisplayName:
          widget.indirectTrip.firstLeg.destinationStationName.isNotEmpty
          ? widget.indirectTrip.firstLeg.destinationStationName
          : widget.indirectTrip.firstLeg.destinationGovernorate,
      date: widget.dateLeg1,
      activeParams: widget.activeParams,
    );
  }

  void _onSummaryConfirm(IndirectBookingState state) async {
    // Navigate to passenger details with the combined payload
    // Wait, the Cart requires calling `addToCart` with individual payloads.
    // We will do this in the PassengerFormScreen? No, PassengerFormScreen directly calls `addToCart`.
    // But PassengerFormScreen only assumes a SINGLE trip.
    // To handle indirect natively: We can call addToCart twice here directly,
    // OR create a new passenger form for indirect trips.
    // Let's create an `IndirectPassengerFormScreen` route later, or handle passengers right here.

    Navigator.pushNamed(
      context,
      AppRoutes.indirectPassengerFormScreen,
      arguments: {'isIndirect': true, 'state': state},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndirectBookingCubit, IndirectBookingState>(
      builder: (context, state) {
        return PopScope(
          canPop: state.currentStep == IndirectBookingStep.searchLeg1,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            _handleBack(state);
          },
          child: Scaffold(
            backgroundColor: ColorsManager.seatBg,
            appBar: AppBar(
              backgroundColor: ColorsManager.surfaceDark,
              title: Text(
                AppLocalizations.of(context)!.buildJourney,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: _Stepper(currentStep: state.currentStep),
              ),
              leading: BackButton(onPressed: () => _handleBack(state)),
            ),
            body: SafeArea(child: _buildStepContent(context, state)),
          ),
        );
      },
    );
  }

  void _handleBack(IndirectBookingState state) {
    final cubit = context.read<IndirectBookingCubit>();

    switch (state.currentStep) {
      case IndirectBookingStep.searchLeg1:
        Navigator.pop(context);
      case IndirectBookingStep.searchLeg2:
        cubit.goBackToLeg1Search();
      case IndirectBookingStep.seatLeg1:
        cubit.goBackToLeg2Search();
      case IndirectBookingStep.seatLeg2:
        cubit.goBackToLeg1Seats();
      case IndirectBookingStep.summary:
        cubit.setStep(IndirectBookingStep.seatLeg2);
    }
  }

  Widget _buildStepContent(BuildContext context, IndirectBookingState state) {
    switch (state.currentStep) {
      case IndirectBookingStep.searchLeg1:
        return _buildSearchLeg1(state);
      case IndirectBookingStep.seatLeg1:
        return _buildSeatLeg1(state);
      case IndirectBookingStep.searchLeg2:
        return _buildSearchLeg2(state);
      case IndirectBookingStep.seatLeg2:
        return _buildSeatLeg2(state);
      case IndirectBookingStep.summary:
        return _buildSummary(state);
    }
  }

  // ── Step 1: Search Leg 1 ──
  Widget _buildSearchLeg1(IndirectBookingState state) {
    if (state.isLoadingLeg1) {
      return const Center(
        child: CircularProgressIndicator(color: ColorsManager.accentCyan),
      );
    }
    if (state.leg1Error != null) {
      return SearchErrorView(
        message: state.leg1Error!,
        onRetry: () => context.read<IndirectBookingCubit>().searchLeg1(
          fromStationId: widget.indirectTrip.firstLeg.originStationId,
          toStationId: widget.indirectTrip.firstLeg.destinationStationId,
          fromDisplayName:
              widget.indirectTrip.firstLeg.originStationName.isNotEmpty
              ? widget.indirectTrip.firstLeg.originStationName
              : widget.indirectTrip.firstLeg.originGovernorate,
          toDisplayName:
              widget.indirectTrip.firstLeg.destinationStationName.isNotEmpty
              ? widget.indirectTrip.firstLeg.destinationStationName
              : widget.indirectTrip.firstLeg.destinationGovernorate,
          date: widget.dateLeg1,
          activeParams: widget.activeParams,
        ),
      );
    }
    if (state.leg1Results == null || state.leg1Results!.isEmpty) {
      return const Center(
        child: Text(
          'No trips available for Leg 1 on the selected date.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!state.isFetchingMoreLeg1 &&
            state.hasMoreLeg1Pages &&
            scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 200) {
          context.read<IndirectBookingCubit>().loadMoreLeg1();
        }
        return false;
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount:
            state.leg1Results!.length + (state.isFetchingMoreLeg1 ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.leg1Results!.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: CircularProgressIndicator(
                  color: ColorsManager.accentCyan,
                ),
              ),
            );
          }
          final t = state.leg1Results![index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TripResultCard(
              trip: t,
              onBookOverride: (trip, coachClass) {
                final cubit = context.read<IndirectBookingCubit>();
                cubit.selectTripLeg1(trip, coachClass);
                cubit.searchLeg2(
                  fromStationId: widget.indirectTrip.secondLeg.originStationId,
                  toStationId:
                      widget.indirectTrip.secondLeg.destinationStationId,
                  fromDisplayName:
                      widget.indirectTrip.secondLeg.originStationName.isNotEmpty
                      ? widget.indirectTrip.secondLeg.originStationName
                      : widget.indirectTrip.secondLeg.originGovernorate,
                  toDisplayName:
                      widget
                          .indirectTrip
                          .secondLeg
                          .destinationStationName
                          .isNotEmpty
                      ? widget.indirectTrip.secondLeg.destinationStationName
                      : widget.indirectTrip.secondLeg.destinationGovernorate,
                  date: widget.dateLeg2,
                  leg1ArrivalTime: trip.arrivalTime ?? DateTime.now(),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // ── Step 2: Seat Leg 1 ──
  Widget _buildSeatLeg1(IndirectBookingState state) {
    // We instantiate SeatMapCubit specifically for this widget. (It lives as long as this step).
    return BlocProvider(
      key: ValueKey('leg1_seat_${state.selectedTripLeg1!.tripOccurrenceId}'),
      create: (_) =>
          sl<SeatMapCubit>()..loadSeatMap(
            state.selectedTripLeg1!.tripOccurrenceId,
            state.selectedClassLeg1!.coachClassId,
          ),
      child: EmbeddedSeatSelection(
        trip: state.selectedTripLeg1!,
        coachClass: state.selectedClassLeg1!,
        onCancel: () =>
            context.read<IndirectBookingCubit>().goBackToLeg2Search(),
        onProceed: (seats) {
          context.read<IndirectBookingCubit>().saveSeatsLeg1(seats);
        },
      ),
    );
  }

  // ── Step 3: Search Leg 2 ──
  Widget _buildSearchLeg2(IndirectBookingState state) {
    if (state.isLoadingLeg2) {
      return const Center(
        child: CircularProgressIndicator(color: ColorsManager.accentCyan),
      );
    }
    if (state.leg2Error != null) {
      return SearchErrorView(
        message: state.leg2Error!,
        onRetry: () => context.read<IndirectBookingCubit>().searchLeg2(
          fromStationId: widget.indirectTrip.secondLeg.originStationId,
          toStationId: widget.indirectTrip.secondLeg.destinationStationId,
          fromDisplayName:
              widget.indirectTrip.secondLeg.originStationName.isNotEmpty
              ? widget.indirectTrip.secondLeg.originStationName
              : widget.indirectTrip.secondLeg.originGovernorate,
          toDisplayName:
              widget.indirectTrip.secondLeg.destinationStationName.isNotEmpty
              ? widget.indirectTrip.secondLeg.destinationStationName
              : widget.indirectTrip.secondLeg.destinationGovernorate,
          date: widget.dateLeg2,
          leg1ArrivalTime:
              state.selectedTripLeg1!.arrivalTime ?? DateTime.now(),
        ),
      );
    }
    if (state.leg2Results == null || state.leg2Results!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.departure_board,
              color: ColorsManager.textMuted,
              size: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              'No connecting trips found.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'There are no valid trips leaving at least 1 hour after your Leg 1 arrival on this date.',
                textAlign: TextAlign.center,
                style: TextStyle(color: ColorsManager.textMuted, fontSize: 14),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(
                  context,
                ); // Jump out of builder entirely to modify dates on the Card.
              },
              icon: const Icon(Icons.edit_calendar),
              label: const Text('Change Travel Dates'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.seatContainerBg,
                foregroundColor: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () =>
                  context.read<IndirectBookingCubit>().goBackToLeg1Search(),
              child: const Text(
                'Back to Leg 1 Trip',
                style: TextStyle(color: ColorsManager.accentCyan),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: ColorsManager.surfaceChip,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () =>
                    context.read<IndirectBookingCubit>().goBackToLeg1Search(),
              ),
              const Expanded(
                child: Text(
                  'Select connection (at least 1h layover)',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (!state.isFetchingMoreLeg2 &&
                  state.hasMoreLeg2Pages &&
                  scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 200) {
                final leg1Arr =
                    state.selectedTripLeg1!.arrivalTime ?? DateTime.now();
                context.read<IndirectBookingCubit>().loadMoreLeg2(leg1Arr);
              }
              return false;
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount:
                  state.leg2Results!.length +
                  (state.isFetchingMoreLeg2 ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.leg2Results!.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ColorsManager.accentCyan,
                      ),
                    ),
                  );
                }
                final t = state.leg2Results![index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TripResultCard(
                    trip: t,
                    onBookOverride: (trip, coachClass) {
                      context.read<IndirectBookingCubit>().selectTripLeg2(
                        trip,
                        coachClass,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // ── Step 4: Seat Leg 2 ──
  Widget _buildSeatLeg2(IndirectBookingState state) {
    return BlocProvider(
      key: ValueKey('leg2_seat_${state.selectedTripLeg2!.tripOccurrenceId}'),
      create: (_) =>
          sl<SeatMapCubit>()..loadSeatMap(
            state.selectedTripLeg2!.tripOccurrenceId,
            state.selectedClassLeg2!.coachClassId,
          ),
      child: EmbeddedSeatSelection(
        trip: state.selectedTripLeg2!,
        coachClass: state.selectedClassLeg2!,
        enforcedSeatCount: state.selectedSeatsLeg1.length,
        onCancel: () =>
            context.read<IndirectBookingCubit>().goBackToLeg1Seats(),
        onProceed: (seats) {
          context.read<IndirectBookingCubit>().saveSeatsLeg2(seats);
        },
      ),
    );
  }

  // ── Step 5: Summary ──
  Widget _buildSummary(IndirectBookingState state) {
    final t1 = state.selectedTripLeg1!;
    final c1 = state.selectedClassLeg1!;
    final s1 = state.selectedSeatsLeg1;

    final t2 = state.selectedTripLeg2!;
    final c2 = state.selectedClassLeg2!;
    final s2 = state.selectedSeatsLeg2;

    final total1 = s1.length * c1.price;
    final total2 = s2.length * c2.price;
    final grand = total1 + total2;
    final loc = AppLocalizations.of(context)!;
    final layover = t2.departureTime.difference(
      t1.arrivalTime ?? t2.departureTime,
    );
    final totalDuration = t2.arrivalTime?.difference(t1.departureTime);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            loc.journeySummary,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _JourneyOverview(
            passengerCount: s1.length,
            layover: layover,
            totalDuration: totalDuration,
            grandTotal: grand,
          ),
          const SizedBox(height: 16),
          _SummaryLegInfo(
            title: loc.legN('1'),
            trip: t1,
            c: c1,
            seats: s1,
            total: total1,
          ),
          const SizedBox(height: 16),
          _SummaryLegInfo(
            title: loc.legN('2'),
            trip: t2,
            c: c2,
            seats: s2,
            total: total2,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loc.grandTotal,
                style: const TextStyle(
                  color: ColorsManager.textMuted,
                  fontSize: 16,
                ),
              ),
              Text(
                '${loc.egp} ${grand.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: ColorsManager.accentCyan,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () => _onSummaryConfirm(state),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.buttonBlue,
              ),
              child: Text(
                loc.proceedToPassenger,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneyOverview extends StatelessWidget {
  final int passengerCount;
  final Duration layover;
  final Duration? totalDuration;
  final double grandTotal;

  const _JourneyOverview({
    required this.passengerCount,
    required this.layover,
    required this.totalDuration,
    required this.grandTotal,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorsManager.borderDim),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _InfoPill(
            icon: Icons.group_outlined,
            label: loc.passengersCount('$passengerCount'),
          ),
          _InfoPill(
            icon: Icons.sync_alt_rounded,
            label:
                '${loc.connectionLayover}: ${_formatDuration(context, layover)}',
          ),
          if (totalDuration != null)
            _InfoPill(
              icon: Icons.schedule_rounded,
              label:
                  '${loc.totalJourneyDuration}: ${_formatDuration(context, totalDuration!)}',
            ),
          _InfoPill(
            icon: Icons.payments_outlined,
            label:
                '${loc.grandTotal}: ${loc.egp} ${grandTotal.toStringAsFixed(0)}',
            highlighted: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryLegInfo extends StatelessWidget {
  final String title;
  final TripResultEntity trip;
  final CoachClassEntity c;
  final List<String> seats;
  final double total;

  const _SummaryLegInfo({
    required this.title,
    required this.trip,
    required this.c,
    required this.seats,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final timeFormat = DateFormat(
      'EEE, d MMM - h:mm a',
      Localizations.localeOf(context).toLanguageTag(),
    );
    final from = _stationLabel(context, trip, isOrigin: true);
    final to = _stationLabel(context, trip, isOrigin: false);
    final agency = _localizedAgency(context, trip);
    final className = _localizedClass(context, c);
    final seatsLabel = seats.where((s) => s.trim().isNotEmpty).join(', ');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceChip,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorsManager.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorsManager.accentCyan.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.route_outlined,
                  color: ColorsManager.accentCyan,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: ColorsManager.accentCyan,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Text(
                '${loc.egp} ${total.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '$from -> $to',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            '$agency - $className',
            style: const TextStyle(
              color: ColorsManager.textMuted,
              fontSize: 13,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          _TimelineRow(
            departure: timeFormat.format(trip.departureTime),
            arrival: trip.arrivalTime == null
                ? loc.noArrivalTime
                : timeFormat.format(trip.arrivalTime!),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoPill(
                icon: Icons.timelapse_rounded,
                label: '${loc.durationLabel}: ${_durationLabel(context, trip)}',
              ),
              _InfoPill(
                icon: Icons.event_seat_outlined,
                label:
                    '${loc.selectedSeats}: ${seatsLabel.isEmpty ? loc.passengersCount('${seats.length}') : seatsLabel}',
              ),
              _InfoPill(
                icon: Icons.sell_outlined,
                label:
                    '${loc.pricePerSeat}: ${loc.egp} ${c.price.toStringAsFixed(0)}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final String departure;
  final String arrival;

  const _TimelineRow({required this.departure, required this.arrival});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: _TimeBlock(
            label: loc.departure,
            value: departure,
            icon: Icons.trip_origin,
          ),
        ),
        Container(width: 30, height: 1, color: ColorsManager.borderSubtle),
        Expanded(
          child: _TimeBlock(
            label: loc.arrival,
            value: arrival,
            icon: Icons.location_on_outlined,
          ),
        ),
      ],
    );
  }
}

class _TimeBlock extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _TimeBlock({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorsManager.borderDim),
      ),
      child: Row(
        children: [
          Icon(icon, color: ColorsManager.accentCyan, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: ColorsManager.textMuted,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlighted;

  const _InfoPill({
    required this.icon,
    required this.label,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = highlighted ? ColorsManager.accentCyan : Colors.white70;
    final maxTextWidth = MediaQuery.sizeOf(context).width - 90;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: highlighted
            ? ColorsManager.accentCyan.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: highlighted
              ? ColorsManager.accentCyan.withValues(alpha: 0.35)
              : Colors.white.withValues(alpha: 0.07),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxTextWidth),
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: highlighted ? FontWeight.bold : FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

String _stationLabel(
  BuildContext context,
  TripResultEntity trip, {
  required bool isOrigin,
}) {
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';
  final station = isOrigin
      ? (isArabic ? trip.originStationNameAr : trip.originStationName)
      : (isArabic
            ? trip.destinationStationNameAr
            : trip.destinationStationName);
  final governorate = isOrigin
      ? (isArabic ? trip.originGovernorateAr : trip.originGovernorate)
      : (isArabic
            ? trip.destinationGovernorateAr
            : trip.destinationGovernorate);
  final fallbackStation = isOrigin
      ? trip.originStationName
      : trip.destinationStationName;
  final fallbackGovernorate = isOrigin
      ? trip.originGovernorate
      : trip.destinationGovernorate;

  final governorateText = governorate?.trim().isNotEmpty == true
      ? governorate!.trim()
      : fallbackGovernorate.trim();
  final stationText = station?.trim().isNotEmpty == true
      ? station!.trim()
      : fallbackStation.trim();
  final subText =
      stationText.isNotEmpty &&
          stationText.toLowerCase() != governorateText.toLowerCase()
      ? stationText
      : '';
  return subText.isEmpty ? governorateText : '$governorateText - $subText';
}

String _localizedAgency(BuildContext context, TripResultEntity trip) {
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';
  if (isArabic && trip.agencyNameAr?.trim().isNotEmpty == true) {
    return trip.agencyNameAr!.trim();
  }
  return trip.agencyName;
}

String _localizedClass(BuildContext context, CoachClassEntity c) {
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';
  if (isArabic && c.classNameAr?.trim().isNotEmpty == true) {
    return c.classNameAr!.trim();
  }
  return c.className;
}

String _durationLabel(BuildContext context, TripResultEntity trip) {
  final minutes = trip.totalDurationMinutes;
  if (minutes == null) return '--';
  return _formatDuration(context, Duration(minutes: minutes));
}

String _formatDuration(BuildContext context, Duration duration) {
  final loc = AppLocalizations.of(context)!;
  final totalMinutes = duration.inMinutes < 0 ? 0 : duration.inMinutes;
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;
  if (hours > 0) {
    return loc.durationHoursMinutes('$hours', '$minutes');
  }
  return loc.durationMinutes('$minutes');
}

class _Stepper extends StatelessWidget {
  final IndirectBookingStep currentStep;

  const _Stepper({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final cur = currentStep.index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: List.generate(5, (index) {
          final color = index <= cur
              ? ColorsManager.accentCyan
              : ColorsManager.borderSubtle;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}
