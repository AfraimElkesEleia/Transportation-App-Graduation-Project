import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/utils/error_localizer.dart';
import 'package:transportation_app/features/booking/presentation/cubit/round_trip_booking_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/round_trip_booking_state.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_cubit.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/embedded_seat_selection.dart';
import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/search_error_view.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/trips_result_card.dart';
import 'package:transportation_app/features/search/presentation/views/widgets/filter_bottom_sheet.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/helper/extensions.dart';

class RoundTripBookingScreen extends StatefulWidget {
  final SearchParams activeParams;

  const RoundTripBookingScreen({super.key, required this.activeParams});

  @override
  State<RoundTripBookingScreen> createState() => _RoundTripBookingScreenState();
}

class _RoundTripBookingScreenState extends State<RoundTripBookingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RoundTripBookingCubit>().searchOutbound(widget.activeParams);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoundTripBookingCubit, RoundTripBookingState>(
      builder: (context, state) {
        return PopScope(
          canPop: state.currentStep == RoundTripBookingStep.searchOutbound,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            _handleBack(state);
          },
          child: Scaffold(
            backgroundColor: ColorsManager.seatBg,
            appBar: AppBar(
              backgroundColor: ColorsManager.surfaceDark,
              title: Text(
                AppLocalizations.of(context)!.roundTrip,
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

  void _handleBack(RoundTripBookingState state) {
    final cubit = context.read<RoundTripBookingCubit>();

    switch (state.currentStep) {
      case RoundTripBookingStep.searchOutbound:
        Navigator.pop(context);
      case RoundTripBookingStep.searchReturn:
        cubit.goBackToOutbound();
      case RoundTripBookingStep.selectSeats:
        cubit.goBackToReturn();
      case RoundTripBookingStep.summary:
        cubit.goBackToSeats();
    }
  }

  void _openFilter(
    BuildContext context,
    RoundTripBookingState state,
    bool isOutbound,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(
        activeParams: state.activeParams!,
        onApply: (newParams) {
          if (isOutbound) {
            context.read<RoundTripBookingCubit>().applyOutboundFilters(
              newParams,
            );
          } else {
            context.read<RoundTripBookingCubit>().applyReturnFilters(newParams);
          }
        },
        onReset: () {
          final reset = state.activeParams!.copyWith(
            transport: TransportType.all,
            sortBy: SortBy.departureTime,
            clearMaxPrice: true,
            preferredAgencies: const [],
            clearTimeFilters: true,
            newPage: 1,
          );
          if (isOutbound) {
            context.read<RoundTripBookingCubit>().applyOutboundFilters(reset);
          } else {
            context.read<RoundTripBookingCubit>().applyReturnFilters(reset);
          }
        },
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, RoundTripBookingState state) {
    switch (state.currentStep) {
      case RoundTripBookingStep.searchOutbound:
        return _buildSearchOutbound(state);
      case RoundTripBookingStep.searchReturn:
        return _buildSearchReturn(state);
      case RoundTripBookingStep.selectSeats:
        return _buildSelectSeats(state);
      case RoundTripBookingStep.summary:
        return _buildSummary(state);
    }
  }

  // ── Stage 1: Outbound Selection ──
  Widget _buildSearchOutbound(RoundTripBookingState state) {
    if (state.isLoadingOutbound) {
      return const Center(
        child: CircularProgressIndicator(color: ColorsManager.accentCyan),
      );
    }
    if (state.outboundError != null) {
      return SearchErrorView(
        message: state.outboundError!,
        onRetry: () => context.read<RoundTripBookingCubit>().searchOutbound(
          widget.activeParams,
        ),
      );
    }
    if (state.outboundResults == null || state.outboundResults!.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noOutbound,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!state.isFetchingMoreOutbound &&
            state.hasMoreOutboundPages &&
            scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 200) {
          context.read<RoundTripBookingCubit>().loadMoreOutbound();
        }
        return false;
      },
      child: CustomScrollView(
        slivers: [
          // ── Sticky header ──
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
                    Text(
                      AppLocalizations.of(context)!.selectOutbound,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.tune,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => _openFilter(context, state, true),
                    ),
                  ],
                ),
              ),
              height: 52,
            ),
          ),

          // ── Trip list ──
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (index == state.outboundResults!.length) {
                  return state.isFetchingMoreOutbound
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
                final t = state.outboundResults![index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TripResultCard(
                    trip: t,
                    onBookOverride: (trip, coachClass) {
                      context.read<RoundTripBookingCubit>().selectOutboundTrip(
                        trip,
                        coachClass,
                      );
                    },
                  ),
                );
              }, childCount: state.outboundResults!.length + 1),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stage 2: Return Selection ──
  Widget _buildSearchReturn(RoundTripBookingState state) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          automaticallyImplyLeading: false,
          backgroundColor: ColorsManager.surfaceDark,
          expandedHeight: 140,
          collapsedHeight: 80,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Container(
              color: ColorsManager.surfaceChip,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    AppLocalizations.of(context)!.outboundSummary,
                    style: const TextStyle(
                      color: ColorsManager.accentCyan,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Builder(
                        builder: (context) {
                          final originStation = context.isArabic
                              ? (state
                                        .selectedOutboundTrip!
                                        .originStationNameAr ??
                                    state
                                        .selectedOutboundTrip!
                                        .originStationName)
                              : state.selectedOutboundTrip!.originStationName;
                          final originGov = context.isArabic
                              ? (state
                                        .selectedOutboundTrip!
                                        .originGovernorateAr ??
                                    state
                                        .selectedOutboundTrip!
                                        .originGovernorate)
                              : state.selectedOutboundTrip!.originGovernorate;
                          final originText = originStation.isNotEmpty
                              ? originStation.toLocalizedStation(context)
                              : originGov.toLocalizedGov(context).toUpperCase();
                          return Text(
                            originText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          final destStation = context.isArabic
                              ? (state
                                        .selectedOutboundTrip!
                                        .destinationStationNameAr ??
                                    state
                                        .selectedOutboundTrip!
                                        .destinationStationName)
                              : state
                                    .selectedOutboundTrip!
                                    .destinationStationName;
                          final destGov = context.isArabic
                              ? (state
                                        .selectedOutboundTrip!
                                        .destinationGovernorateAr ??
                                    state
                                        .selectedOutboundTrip!
                                        .destinationGovernorate)
                              : state
                                    .selectedOutboundTrip!
                                    .destinationGovernorate;
                          final destText = destStation.isNotEmpty
                              ? destStation.toLocalizedStation(context)
                              : destGov.toLocalizedGov(context).toUpperCase();
                          return Text(
                            destText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.arrivesAt(
                      _formatTime(state.selectedOutboundTrip!.arrivalTime),
                    ),
                    style: const TextStyle(color: ColorsManager.textMuted),
                  ),
                ],
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.selectReturn,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.tune, color: Colors.white, size: 20),
                  onPressed: () => _openFilter(context, state, false),
                ),
              ],
            ),
            titlePadding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
          ),
        ),
        if (state.isLoadingReturn)
          const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(color: ColorsManager.accentCyan),
            ),
          )
        else if (state.returnError != null)
          SliverFillRemaining(
            child: SearchErrorView(
              message: state.returnError!,
              onRetry: () =>
                  context.read<RoundTripBookingCubit>().selectOutboundTrip(
                    state.selectedOutboundTrip!,
                    state.selectedOutboundClass!,
                  ),
            ),
          )
        else if (state.returnResults == null || state.returnResults!.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.noReturn,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (index == state.returnResults!.length) {
                  if (!state.isFetchingMoreReturn && state.hasMoreReturnPages) {
                    context.read<RoundTripBookingCubit>().loadMoreReturn();
                  }
                  return state.isFetchingMoreReturn
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
                final t = state.returnResults![index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TripResultCard(
                    trip: t,
                    onBookOverride: (trip, coachClass) {
                      context.read<RoundTripBookingCubit>().selectReturnTrip(
                        trip,
                        coachClass,
                      );
                    },
                  ),
                );
              }, childCount: state.returnResults!.length + 1),
            ),
          ),
      ],
    );
  }

  // ── Stage 3: Unified Seat Selection ──
  Widget _buildSelectSeats(RoundTripBookingState state) {
    return _UnifiedSeatSelectionLayer(
      outboundTrip: state.selectedOutboundTrip!,
      outboundClass: state.selectedOutboundClass!,
      returnTrip: state.selectedReturnTrip!,
      returnClass: state.selectedReturnClass!,
      requiredSeats: state.requiredSeatCount,
      initialOutboundSeats: state.selectedOutboundSeats,
      initialReturnSeats: state.selectedReturnSeats,
      onProceed: (outbound, returnSeats) {
        context.read<RoundTripBookingCubit>().saveUnifiedSeats(
          outbound,
          returnSeats,
        );
      },
    );
  }

  // ── Stage 4: Summary ──
  Widget _buildSummary(RoundTripBookingState state) {
    final t1 = state.selectedOutboundTrip!;
    final c1 = state.selectedOutboundClass!;
    final s1 = state.selectedOutboundSeats;

    final t2 = state.selectedReturnTrip!;
    final c2 = state.selectedReturnClass!;
    final s2 = state.selectedReturnSeats;

    final total1 = s1.length * c1.price;
    final total2 = s2.length * c2.price;
    final grand = total1 + total2;
    final outboundDuration = t1.totalDurationMinutes;
    final returnDuration = t2.totalDurationMinutes;
    final totalDuration = outboundDuration == null || returnDuration == null
        ? null
        : Duration(minutes: outboundDuration + returnDuration);

    return BlocConsumer<RoundTripBookingCubit, RoundTripBookingState>(
      listenWhen: (prev, current) =>
          prev.cartError != current.cartError || current.cartSuccess,
      listener: (context, current) {
        if (current.cartSuccess) {
          // Navigate to passenger form
          Navigator.pushNamed(
            context,
            AppRoutes.roundTripPassengerFormScreen,
            arguments: context.read<RoundTripBookingCubit>(),
          );
        } else if (current.cartError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ErrorLocalizer.localize(context, current.cartError!),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.roundTripSummary,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _RoundTripOverview(
                outboundSeats: s1.length,
                returnSeats: s2.length,
                totalDuration: totalDuration,
                grandTotal: grand,
              ),
              const SizedBox(height: 16),
              _SummaryLegInfo(
                title: AppLocalizations.of(context)!.outbound,
                trip: t1,
                c: c1,
                seats: s1,
                total: total1,
              ),
              const SizedBox(height: 16),
              _SummaryLegInfo(
                title: AppLocalizations.of(context)!.returnTrip,
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
                    AppLocalizations.of(context)!.grandTotal,
                    style: const TextStyle(
                      color: ColorsManager.textMuted,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.egp} $grand',
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
                  onPressed: state.isAddingToCart
                      ? null
                      : () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.roundTripPassengerFormScreen,
                            arguments: context.read<RoundTripBookingCubit>(),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.buttonBlue,
                  ),
                  child: state.isAddingToCart
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
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
      },
    );
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '--:--';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// ── Unified Seat Selection Layer (handles lazy loading) ──
class _UnifiedSeatSelectionLayer extends StatefulWidget {
  final TripResultEntity outboundTrip;
  final CoachClassEntity outboundClass;
  final TripResultEntity returnTrip;
  final CoachClassEntity returnClass;
  final int requiredSeats;
  final List<String> initialOutboundSeats;
  final List<String> initialReturnSeats;
  final Function(List<String> outboundSeats, List<String> returnSeats)
  onProceed;

  const _UnifiedSeatSelectionLayer({
    required this.outboundTrip,
    required this.outboundClass,
    required this.returnTrip,
    required this.returnClass,
    required this.requiredSeats,
    required this.initialOutboundSeats,
    required this.initialReturnSeats,
    required this.onProceed,
  });

  @override
  State<_UnifiedSeatSelectionLayer> createState() =>
      _UnifiedSeatSelectionLayerState();
}

class _UnifiedSeatSelectionLayerState
    extends State<_UnifiedSeatSelectionLayer> {
  late List<String> _selectedOutbound;
  late List<String> _selectedReturn;
  bool _returnMapVisible = false;

  @override
  void initState() {
    super.initState();
    _selectedOutbound = List.from(widget.initialOutboundSeats);
    _selectedReturn = List.from(widget.initialReturnSeats);
    if (_selectedOutbound.isNotEmpty) {
      _returnMapVisible = true;
    }
  }

  void _onOutboundSeatsChanged(List<String> seats) {
    setState(() {
      _selectedOutbound = seats;
      if (_selectedOutbound.isNotEmpty) {
        _returnMapVisible = true;
      }
    });
  }

  void _onReturnSeatsChanged(List<String> seats) {
    setState(() {
      _selectedReturn = seats;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    // Seat maps need an explicit height — they use Expanded internally.
    // MediaQuery gives us a reliable fraction of screen height.
    final seatMapHeight = MediaQuery.of(context).size.height * 0.90;

    return CustomScrollView(
      slivers: [
        // ── Step 1 header ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.step1Seats,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () =>
                      context.read<RoundTripBookingCubit>().goBackToReturn(),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 14,
                    color: ColorsManager.accentCyan,
                  ),
                  label: Text(
                    AppLocalizations.of(context)!.previous,
                    style: const TextStyle(color: ColorsManager.accentCyan),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Outbound seat map (fixed height) ──
        SliverToBoxAdapter(
          child: SizedBox(
            height: seatMapHeight,
            child: BlocProvider(
              key: ValueKey(
                'outbound_seat_${widget.outboundTrip.tripOccurrenceId}',
              ),
              create: (_) =>
                  sl<SeatMapCubit>()
                    ..loadSeatMap(
                      widget.outboundTrip.tripOccurrenceId,
                      widget.outboundClass.coachClassId,
                    ),
              child: EmbeddedSeatSelection(
                trip: widget.outboundTrip,
                coachClass: widget.outboundClass,
                enforcedSeatCount: null,
                initialSeats: _selectedOutbound,
                onCancel: () =>
                    context.read<RoundTripBookingCubit>().goBackToReturn(),
                onProceed: _onOutboundSeatsChanged,
              ),
            ),
          ),
        ),

        // ── Divider + Step 2 (only when outbound seats chosen) ──
        if (_returnMapVisible) ...[
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Icon(
                Icons.link,
                color: ColorsManager.accentCyan,
                size: 32,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AppLocalizations.of(context)!.step2Seats,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // ── Return seat map (fixed height) ──
          SliverToBoxAdapter(
            child: SizedBox(
              height: seatMapHeight,
              child: BlocProvider(
                key: ValueKey(
                  'return_seat_${widget.returnTrip.tripOccurrenceId}',
                ),
                create: (_) =>
                    sl<SeatMapCubit>()
                      ..loadSeatMap(
                        widget.returnTrip.tripOccurrenceId,
                        widget.returnClass.coachClassId,
                      ),
                child: EmbeddedSeatSelection(
                  trip: widget.returnTrip,
                  coachClass: widget.returnClass,
                  enforcedSeatCount: null, // ← no restriction
                  initialSeats: _selectedReturn,
                  onCancel: () => setState(() => _returnMapVisible = false),
                  onProceed: (seats) {
                    _onReturnSeatsChanged(seats);
                    widget.onProceed(_selectedOutbound, seats);
                  },
                ),
              ),
            ),
          ),
        ],

        // Bottom breathing room
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _RoundTripOverview extends StatelessWidget {
  final int outboundSeats;
  final int returnSeats;
  final Duration? totalDuration;
  final double grandTotal;

  const _RoundTripOverview({
    required this.outboundSeats,
    required this.returnSeats,
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
            icon: Icons.flight_takeoff_rounded,
            label: '${loc.outbound}: ${loc.nSeats('$outboundSeats')}',
          ),
          _InfoPill(
            icon: Icons.keyboard_return_rounded,
            label: '${loc.returnTrip}: ${loc.nSeats('$returnSeats')}',
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

class _Stepper extends StatelessWidget {
  final RoundTripBookingStep currentStep;

  const _Stepper({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final cur = currentStep.index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: List.generate(4, (index) {
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

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  const _StickyHeaderDelegate({required this.child, required this.height});

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
  bool shouldRebuild(_StickyHeaderDelegate old) =>
      old.height != height || old.child != child;
}
