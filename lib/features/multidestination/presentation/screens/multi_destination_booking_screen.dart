import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/multidestination/presentation/cubit/multi_destination_booking_cubit.dart';
import 'package:transportation_app/features/multidestination/presentation/cubit/multi_destination_booking_state.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_cubit.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/embedded_seat_selection.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/search_error_view.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/trips_result_card.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/filter_bottom_sheet.dart';

class MultiDestinationBookingScreen extends StatefulWidget {
  const MultiDestinationBookingScreen({super.key});

  @override
  State<MultiDestinationBookingScreen> createState() => _MultiDestinationBookingScreenState();
}

class _MultiDestinationBookingScreenState extends State<MultiDestinationBookingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MultiDestinationBookingCubit>().startFlow();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MultiDestinationBookingCubit, MultiDestinationBookingState>(
      builder: (context, state) {
        final totalSteps = (state.legSummaries.length * 2) + 1;
        int currentProgress = 0;
        
        if (state.currentStep == MultiDestinationBookingStep.searchLegs) {
          currentProgress = state.currentSearchLegIndex;
        } else if (state.currentStep == MultiDestinationBookingStep.selectSeats) {
          currentProgress = state.legSummaries.length + state.currentSeatLegIndex;
        } else {
          currentProgress = totalSteps - 1;
        }
        
        final progressPercent = totalSteps > 0 ? (currentProgress / totalSteps) : 0.0;

        return Scaffold(
          backgroundColor: ColorsManager.seatBg,
          appBar: AppBar(
            backgroundColor: ColorsManager.surfaceDark,
            title: const Text('Multi-Destination', style: TextStyle(color: Colors.white, fontSize: 16)),
            iconTheme: const IconThemeData(color: Colors.white),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: progressPercent,
                    backgroundColor: Colors.white24,
                    color: ColorsManager.accentCyan,
                    minHeight: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _getStepText(state),
                      style: const TextStyle(color: ColorsManager.accentCyan, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            leading: BackButton(
              onPressed: () {
                if (currentProgress == 0) {
                  Navigator.pop(context);
                } else {
                  context.read<MultiDestinationBookingCubit>().goBack();
                }
              },
            ),
          ),
          body: SafeArea(child: _buildStepContent(context, state)),
        );
      },
    );
  }

  String _getStepText(MultiDestinationBookingState state) {
    if (state.currentStep == MultiDestinationBookingStep.searchLegs) {
      return "Select Trip for Leg ${state.currentSearchLegIndex + 1}";
    } else if (state.currentStep == MultiDestinationBookingStep.selectSeats) {
      return "Select Seats for Leg ${state.currentSeatLegIndex + 1}";
    }
    return "Review & Checkout";
  }

  Widget _buildStepContent(BuildContext context, MultiDestinationBookingState state) {
    if (state.currentStep == MultiDestinationBookingStep.searchLegs) {
      return _buildSearchLeg(state);
    } else if (state.currentStep == MultiDestinationBookingStep.selectSeats) {
      return _buildSelectSeats(state);
    } else {
      return _buildSummary(state);
    }
  }

  Widget _buildSearchLeg(MultiDestinationBookingState state) {
    if (state.isSearching) {
      return const Center(child: CircularProgressIndicator(color: ColorsManager.accentCyan));
    }
    if (state.searchError != null) {
      return SearchErrorView(
        message: state.searchError!,
        onRetry: () => context.read<MultiDestinationBookingCubit>().startFlow(),
      );
    }
    if (state.searchResults == null || state.searchResults!.isEmpty) {
      return const Center(child: Text('No trips available for this leg.', style: TextStyle(color: Colors.white)));
    }

    final leg = state.legSummaries[state.currentSearchLegIndex];

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!state.isFetchingMore && state.currentPage < state.totalPages &&
            scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
          context.read<MultiDestinationBookingCubit>().loadMore();
        }
        return false;
      },
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              child: Container(
                color: ColorsManager.surfaceChip,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${leg.from} ➔ ${leg.to}',
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.tune, color: Colors.white, size: 20),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => FilterBottomSheet(
                            activeParams: state.currentActiveParams!,
                            onApply: (newParams) {
                              context.read<MultiDestinationBookingCubit>().applyFilters(newParams);
                            },
                            onReset: () {
                              final resetParams = state.currentActiveParams!.copyWith(
                                transport: TransportType.all,
                                sortBy: SortBy.departureTime,
                                clearMaxPrice: true,
                                clearTimeFilters: true,
                                newPage: 1,
                              );
                              context.read<MultiDestinationBookingCubit>().applyFilters(resetParams);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              height: 52,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (index == state.searchResults!.length) {
                  return state.isFetchingMore
                      ? const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Center(child: CircularProgressIndicator(color: ColorsManager.accentCyan)))
                      : const SizedBox.shrink();
                }
                final t = state.searchResults![index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TripResultCard(
                    trip: t,
                    onBookOverride: (trip, coachClass) {
                      context.read<MultiDestinationBookingCubit>().selectTripForLeg(trip, coachClass);
                    },
                  ),
                );
              }, childCount: state.searchResults!.length + 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectSeats(MultiDestinationBookingState state) {
    final legIndex = state.currentSeatLegIndex;
    final trip = state.selectedTrips[legIndex]!;
    final cClass = state.selectedClasses[legIndex]!;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Select Seats for Leg ${legIndex + 1}',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: BlocProvider(
              key: ValueKey('seat_leg_$legIndex'),
              create: (_) => SeatMapCubit(datasource: sl<BookingRemoteDatasource>())..loadSeatMap(trip.tripOccurrenceId, cClass.coachClassId),
              child: EmbeddedSeatSelection(
                trip: trip,
                coachClass: cClass,
                enforcedSeatCount: null,   // ← no restriction per leg
                initialSeats: state.selectedSeats[legIndex] ?? [],
                onCancel: () => context.read<MultiDestinationBookingCubit>().goBack(),
                onProceed: (seats) {
                  context.read<MultiDestinationBookingCubit>().saveSeatsForCurrentLeg(seats);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummary(MultiDestinationBookingState state) {
    double grandTotal = 0;
    for (int i = 0; i < state.legSummaries.length; i++) {
      grandTotal += (state.selectedSeats[i]?.length ?? 0) * (state.selectedClasses[i]?.price ?? 0);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Journey Summary', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          for (int i = 0; i < state.legSummaries.length; i++) ...[
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: ColorsManager.surfaceChip, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Leg ${i + 1}', style: const TextStyle(color: ColorsManager.accentCyan, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('${state.selectedTrips[i]!.originStationName} ➔ ${state.selectedTrips[i]!.destinationStationName}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                  Text('${state.selectedTrips[i]!.agencyName} - ${state.selectedClasses[i]!.className}', style: const TextStyle(color: ColorsManager.textMuted, fontSize: 13)),
                  const SizedBox(height: 8),
                  Text('${state.selectedSeats[i]?.length ?? 0} Seats: ${state.selectedSeats[i]?.join(", ")}', style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Grand Total', style: TextStyle(color: ColorsManager.textMuted, fontSize: 16)),
              Text('EGP $grandTotal', style: const TextStyle(color: ColorsManager.accentCyan, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.multidestinationPassengerFormScreen,
                  arguments: context.read<MultiDestinationBookingCubit>(),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: ColorsManager.buttonBlue),
              child: const Text('Proceed to Passenger Details', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  _StickyHeaderDelegate({required this.child, required this.height});
  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;
  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) => true;
}
