import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/booking/data/datasources/booking_remote_datasource.dart';
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
        return Scaffold(
          backgroundColor: ColorsManager.seatBg,
          appBar: AppBar(
            backgroundColor: ColorsManager.surfaceDark,
            title: const Text(
              'Build Journey',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: _Stepper(currentStep: state.currentStep),
            ),
          ),
          body: SafeArea(child: _buildStepContent(context, state)),
        );
      },
    );
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
                context.read<IndirectBookingCubit>().selectTripLeg1(
                  trip,
                  coachClass,
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
          SeatMapCubit(datasource: sl<BookingRemoteDatasource>())..loadSeatMap(
            state.selectedTripLeg1!.tripOccurrenceId,
            state.selectedClassLeg1!.coachClassId,
          ),
      child: EmbeddedSeatSelection(
        trip: state.selectedTripLeg1!,
        coachClass: state.selectedClassLeg1!,
        onCancel: () =>
            context.read<IndirectBookingCubit>().goBackToLeg1Search(),
        onProceed: (seats) {
          context.read<IndirectBookingCubit>().saveSeatsLeg1(seats);
          // Trigger search Leg 2
          context.read<IndirectBookingCubit>().searchLeg2(
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
          );
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
                  context.read<IndirectBookingCubit>().goBackToLeg1Seats(),
              child: const Text(
                'Back to Leg 1 Details',
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
                    context.read<IndirectBookingCubit>().goBackToLeg1Seats(),
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
          SeatMapCubit(datasource: sl<BookingRemoteDatasource>())..loadSeatMap(
            state.selectedTripLeg2!.tripOccurrenceId,
            state.selectedClassLeg2!.coachClassId,
          ),
      child: EmbeddedSeatSelection(
        trip: state.selectedTripLeg2!,
        coachClass: state.selectedClassLeg2!,
        enforcedSeatCount: state.requiredSeatCount,
        onCancel: () =>
            context.read<IndirectBookingCubit>().clearLeg2Selection(),
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Journey Summary',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _SummaryLegInfo(
            title: 'Leg 1',
            trip: t1,
            c: c1,
            seats: s1,
            total: total1,
          ),
          const SizedBox(height: 16),
          _SummaryLegInfo(
            title: 'Leg 2',
            trip: t2,
            c: c2,
            seats: s2,
            total: total2,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Grand Total',
                style: TextStyle(color: ColorsManager.textMuted, fontSize: 16),
              ),
              Text(
                'EGP $grand',
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
              child: const Text(
                'Proceed to Passenger Details',
                style: TextStyle(
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceChip,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: ColorsManager.accentCyan,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${trip.originStationName.isNotEmpty ? trip.originStationName : trip.originGovernorate} ➔ ${trip.destinationStationName.isNotEmpty ? trip.destinationStationName : trip.destinationGovernorate}',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            '${trip.agencyName} - ${c.className}',
            style: const TextStyle(
              color: ColorsManager.textMuted,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${seats.length} Seats',
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                'EGP $total',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
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
