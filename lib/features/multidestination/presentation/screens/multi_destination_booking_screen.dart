import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/helper/extensions.dart';
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
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';

class MultiDestinationBookingScreen extends StatefulWidget {
  const MultiDestinationBookingScreen({super.key});

  @override
  State<MultiDestinationBookingScreen> createState() =>
      _MultiDestinationBookingScreenState();
}

class _MultiDestinationBookingScreenState
    extends State<MultiDestinationBookingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MultiDestinationBookingCubit>().startFlow();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      MultiDestinationBookingCubit,
      MultiDestinationBookingState
    >(
      builder: (context, state) {
        final totalSteps = (state.legSummaries.length * 2) + 1;
        int currentProgress = 0;

        if (state.currentStep == MultiDestinationBookingStep.searchLegs) {
          currentProgress = state.currentSearchLegIndex;
        } else if (state.currentStep ==
            MultiDestinationBookingStep.selectSeats) {
          currentProgress =
              state.legSummaries.length + state.currentSeatLegIndex;
        } else {
          currentProgress = totalSteps - 1;
        }

        final progressPercent = totalSteps > 0
            ? (currentProgress / totalSteps)
            : 0.0;

        return PopScope(
          canPop: currentProgress == 0,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            _handleBack(currentProgress);
          },
          child: Scaffold(
            backgroundColor: ColorsManager.seatBg,
            appBar: AppBar(
              backgroundColor: ColorsManager.surfaceDark,
              title: Text(
                AppLocalizations.of(context)!.multiDestination,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
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
                        style: const TextStyle(
                          color: ColorsManager.accentCyan,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              leading: BackButton(
                onPressed: () => _handleBack(currentProgress),
              ),
            ),
            body: SafeArea(child: _buildStepContent(context, state)),
          ),
        );
      },
    );
  }

  void _handleBack(int currentProgress) {
    if (currentProgress == 0) {
      Navigator.pop(context);
      return;
    }

    context.read<MultiDestinationBookingCubit>().goBack();
  }

  String _getStepText(MultiDestinationBookingState state) {
    if (state.currentStep == MultiDestinationBookingStep.searchLegs) {
      return AppLocalizations.of(
        context,
      )!.selectTripForLeg('${state.currentSearchLegIndex + 1}');
    } else if (state.currentStep == MultiDestinationBookingStep.selectSeats) {
      return AppLocalizations.of(
        context,
      )!.selectSeatsForLeg('${state.currentSeatLegIndex + 1}');
    }
    return AppLocalizations.of(context)!.reviewCheckout;
  }

  Widget _buildStepContent(
    BuildContext context,
    MultiDestinationBookingState state,
  ) {
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
      return const Center(
        child: CircularProgressIndicator(color: ColorsManager.accentCyan),
      );
    }
    if (state.searchError != null) {
      return SearchErrorView(
        message: state.searchError!,
        onRetry: () => context.read<MultiDestinationBookingCubit>().startFlow(),
      );
    }

    // NOTE: We do NOT return early for empty results here.
    // The sticky header (with the filter button) must always be visible so the
    // user can adjust filters when no results match.
    final leg = state.legSummaries[state.currentSearchLegIndex];
    final hasResults =
        state.searchResults != null && state.searchResults!.isNotEmpty;

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!state.isFetchingMore &&
            state.currentPage < state.totalPages &&
            scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 200) {
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
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        textDirection: TextDirection.ltr,
                        children: [
                          Flexible(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              textDirection: TextDirection.ltr,
                              children: [
                                Flexible(
                                  child: Text(
                                    leg.fromGov.toLocalizedGov(context),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (leg.fromSub != null &&
                                    leg.fromSub!.isNotEmpty) ...[
                                  const Text(
                                    ' - ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      leg.fromSub!.toLocalizedStation(context),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              '➔',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              textDirection: TextDirection.ltr,
                              children: [
                                Flexible(
                                  child: Text(
                                    leg.toGov.toLocalizedGov(context),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (leg.toSub != null &&
                                    leg.toSub!.isNotEmpty) ...[
                                  const Text(
                                    ' - ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      leg.toSub!.toLocalizedStation(context),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.tune,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => FilterBottomSheet(
                            activeParams: state.currentActiveParams!,
                            onApply: (newParams) {
                              context
                                  .read<MultiDestinationBookingCubit>()
                                  .applyFilters(newParams);
                            },
                            onReset: () {
                              final resetParams = state.currentActiveParams!
                                  .copyWith(
                                    transport: TransportType.all,
                                    sortBy: SortBy.departureTime,
                                    clearMaxPrice: true,
                                    clearTimeFilters: true,
                                    newPage: 1,
                                  );
                              context
                                  .read<MultiDestinationBookingCubit>()
                                  .applyFilters(resetParams);
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
          if (!hasResults)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.search_off_rounded,
                      color: Colors.white24,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.noTripsFoundForLeg,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.tryAdjustingFilters,
                      style: const TextStyle(
                        color: Colors.white30,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (index == state.searchResults!.length) {
                    return state.isFetchingMore
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: ColorsManager.accentCyan,
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  }
                  final t = state.searchResults![index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TripResultCard(
                      trip: t,
                      onBookOverride: (trip, coachClass) {
                        context
                            .read<MultiDestinationBookingCubit>()
                            .selectTripForLeg(trip, coachClass);
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
              AppLocalizations.of(
                context,
              )!.selectSeatsForLeg('${legIndex + 1}'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: BlocProvider(
              key: ValueKey('seat_leg_$legIndex'),
              create: (_) =>
                  SeatMapCubit(datasource: sl<BookingRemoteDatasource>())
                    ..loadSeatMap(trip.tripOccurrenceId, cClass.coachClassId),
              child: EmbeddedSeatSelection(
                trip: trip,
                coachClass: cClass,
                enforcedSeatCount: null, // ← no restriction per leg
                initialSeats: state.selectedSeats[legIndex] ?? [],
                onCancel: () =>
                    context.read<MultiDestinationBookingCubit>().goBack(),
                onProceed: (seats) {
                  context
                      .read<MultiDestinationBookingCubit>()
                      .saveSeatsForCurrentLeg(seats);
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
    int totalSeats = 0;
    int? totalDurationMinutes = 0;

    for (int i = 0; i < state.legSummaries.length; i++) {
      final seatCount = state.selectedSeats[i]?.length ?? 0;
      grandTotal += seatCount * (state.selectedClasses[i]?.price ?? 0);
      totalSeats += seatCount;

      final duration = state.selectedTrips[i]?.totalDurationMinutes;
      totalDurationMinutes = totalDurationMinutes == null || duration == null
          ? null
          : totalDurationMinutes + duration;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context)!.journeySummary,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _MultiDestinationOverview(
            legCount: state.legSummaries.length,
            seatCount: totalSeats,
            totalDuration: totalDurationMinutes == null
                ? null
                : Duration(minutes: totalDurationMinutes),
            grandTotal: grandTotal,
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < state.legSummaries.length; i++) ...[
            _SummaryLegInfo(
              title: AppLocalizations.of(context)!.legN('${i + 1}'),
              trip: state.selectedTrips[i]!,
              c: state.selectedClasses[i]!,
              seats: state.selectedSeats[i] ?? const [],
              total:
                  (state.selectedSeats[i]?.length ?? 0) *
                  state.selectedClasses[i]!.price,
            ),
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.grandTotal,
                style: const TextStyle(
                  color: ColorsManager.textMuted,
                  fontSize: 16,
                ),
              ),
              Text(
                '${AppLocalizations.of(context)!.egp} ${grandTotal.toStringAsFixed(0)}',
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
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.multidestinationPassengerFormScreen,
                  arguments: context.read<MultiDestinationBookingCubit>(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.buttonBlue,
              ),
              child: Text(
                AppLocalizations.of(context)!.proceedToPassenger,
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

class _MultiDestinationOverview extends StatelessWidget {
  final int legCount;
  final int seatCount;
  final Duration? totalDuration;
  final double grandTotal;

  const _MultiDestinationOverview({
    required this.legCount,
    required this.seatCount,
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
            icon: Icons.route_outlined,
            label: loc.legsCount('$legCount'),
          ),
          _InfoPill(
            icon: Icons.event_seat_outlined,
            label: loc.nSeats('$seatCount'),
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
                    '${loc.selectedSeats}: ${seatsLabel.isEmpty ? loc.nSeats('${seats.length}') : seatsLabel}',
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

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  _StickyHeaderDelegate({required this.child, required this.height});
  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;
  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) => true;
}
