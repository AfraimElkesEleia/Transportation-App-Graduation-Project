import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/domain/usecases/search_trips_usecase.dart';
import 'package:transportation_app/features/booking/presentation/cubit/indirect_booking_state.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';
import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';

class IndirectBookingCubit extends Cubit<IndirectBookingState> {
  final SearchTripsUseCase searchTripsUseCase;

  IndirectBookingCubit({
    required this.searchTripsUseCase,
  }) : super(const IndirectBookingState());

  void setStep(IndirectBookingStep step) {
    emit(state.copyWith(currentStep: step));
  }

  // ── Leg 1 ──

  Future<void> searchLeg1({
    required SearchParams activeParams,
    required int fromStationId,
    required int toStationId,
    required String fromDisplayName,
    required String toDisplayName,
    required DateTime date,
  }) async {
    emit(state.copyWith(
      isLoadingLeg1: true,
      clearLeg1Error: true,
      leg1Results: [],
      requiredSeatCount: activeParams.passengers,
      activeParams: activeParams,
    ));

    // Well, we will build a new one using the attributes from activeParams
    final newParams = SearchParams(
      fromStationId: fromStationId,
      toStationId: toStationId,
      fromDisplayName: fromDisplayName,
      toDisplayName: toDisplayName,
      travelDate: date.toIso8601String().split('T').first,
      passengers: activeParams.passengers,
      transport: activeParams.transport,
      sortBy: activeParams.sortBy,
      maxPrice: activeParams.maxPrice,
      preferredAgencies: activeParams.preferredAgencies,
      departureFrom: activeParams.departureFrom,
      departureTo: activeParams.departureTo,
      arrivalFrom: activeParams.arrivalFrom,
      arrivalTo: activeParams.arrivalTo,
    );

    final result = await searchTripsUseCase(newParams);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingLeg1: false,
        leg1Error: failure.message,
      )),
      (paged) => emit(state.copyWith(
        isLoadingLeg1: false,
        leg1Results: _applyTimeFilters(paged.items, newParams),
        leg1CurrentPage: paged.currentPage,
        leg1TotalPages: paged.totalPages,
        leg1SearchParams: newParams,
      )),
    );
  }

  Future<void> loadMoreLeg1() async {
    if (isClosed) return;
    if (state.isFetchingMoreLeg1 || !state.hasMoreLeg1Pages) return;
    final baseParams = state.leg1SearchParams;
    if (baseParams == null) return;

    emit(state.copyWith(isFetchingMoreLeg1: true));

    final newParams = baseParams.copyWith(newPage: state.leg1CurrentPage + 1);

    final result = await searchTripsUseCase(newParams);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(isFetchingMoreLeg1: false)),
      (paged) {
        final existingIds = (state.leg1Results ?? const <TripResultEntity>[])
            .map((t) => t.tripOccurrenceId)
            .toSet();
        final newItems = _applyTimeFilters(paged.items, newParams)
            .where((t) => !existingIds.contains(t.tripOccurrenceId))
            .toList();
        
        emit(state.copyWith(
          isFetchingMoreLeg1: false,
          leg1Results: [
            ...(state.leg1Results ?? const <TripResultEntity>[]),
            ...newItems,
          ],
          leg1CurrentPage: paged.currentPage,
          leg1TotalPages: paged.totalPages,
          leg1SearchParams: newParams,
        ));
      },
    );
  }

  void selectTripLeg1(TripResultEntity trip, CoachClassEntity coachClass) {
    emit(state.copyWith(
      selectedTripLeg1: trip,
      selectedClassLeg1: coachClass,
      selectedSeatsLeg1: const [], // reset
      selectedSeatsLeg2: const [],
      clearLeg2Selection: true,
      currentStep: IndirectBookingStep.searchLeg2,
    ));
  }

  void saveSeatsLeg1(List<String> seats) {
    emit(state.copyWith(
      selectedSeatsLeg1: seats,
      currentStep: IndirectBookingStep.seatLeg2,
    ));
  }

  // ── Leg 2 ──

  Future<void> searchLeg2({
    required int fromStationId,
    required int toStationId,
    required String fromDisplayName,
    required String toDisplayName,
    required DateTime date,
    required DateTime leg1ArrivalTime,
    SearchParams? activeParams,
  }) async {
    final effectiveParams = activeParams ?? state.activeParams;
    emit(state.copyWith(
      isLoadingLeg2: true,
      clearLeg2Error: true,
      leg2Results: [],
      activeParams: effectiveParams,
    ));

    final newParams = SearchParams(
      fromStationId: fromStationId,
      toStationId: toStationId,
      fromDisplayName: fromDisplayName,
      toDisplayName: toDisplayName,
      travelDate: date.toIso8601String().split('T').first,
      passengers: state.requiredSeatCount,
      transport: effectiveParams?.transport ?? TransportType.all,
      sortBy: effectiveParams?.sortBy ?? SortBy.departureTime,
      maxPrice: effectiveParams?.maxPrice,
      preferredAgencies: effectiveParams?.preferredAgencies ?? const [],
      departureFrom: effectiveParams?.departureFrom,
      departureTo: effectiveParams?.departureTo,
      arrivalFrom: effectiveParams?.arrivalFrom,
      arrivalTo: effectiveParams?.arrivalTo,
    );

    final result = await searchTripsUseCase(newParams);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingLeg2: false,
        leg2Error: failure.message,
      )),
      (paged) {
        final safeDepartureTime = leg1ArrivalTime.add(const Duration(minutes: 60));

        final validTrips = _applyTimeFilters(paged.items, newParams).where((t) {
          return t.departureTime.isAfter(safeDepartureTime);
        }).toList();

        emit(state.copyWith(
          isLoadingLeg2: false,
          leg2Results: validTrips,
          leg2CurrentPage: paged.currentPage,
          leg2TotalPages: paged.totalPages,
          leg2SearchParams: newParams,
        ));
      },
    );
  }

  Future<void> loadMoreLeg2(DateTime leg1ArrivalTime) async {
    if (isClosed) return;
    if (state.isFetchingMoreLeg2 || !state.hasMoreLeg2Pages) return;
    final baseParams = state.leg2SearchParams;
    if (baseParams == null) return;

    emit(state.copyWith(isFetchingMoreLeg2: true));

    final newParams = baseParams.copyWith(newPage: state.leg2CurrentPage + 1);

    final result = await searchTripsUseCase(newParams);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(isFetchingMoreLeg2: false)),
      (paged) {
        final existingIds = (state.leg2Results ?? const <TripResultEntity>[])
            .map((t) => t.tripOccurrenceId)
            .toSet();
        
        final safeDepartureTime = leg1ArrivalTime.add(const Duration(minutes: 60));
        
        final newItems = _applyTimeFilters(paged.items, newParams).where((t) {
          if (existingIds.contains(t.tripOccurrenceId)) return false;
          return t.departureTime.isAfter(safeDepartureTime);
        }).toList();
        
        emit(state.copyWith(
          isFetchingMoreLeg2: false,
          leg2Results: [
            ...(state.leg2Results ?? const <TripResultEntity>[]),
            ...newItems,
          ],
          leg2CurrentPage: paged.currentPage,
          leg2TotalPages: paged.totalPages,
          leg2SearchParams: newParams,
        ));
      },
    );
  }

  void selectTripLeg2(TripResultEntity trip, CoachClassEntity coachClass) {
    emit(state.copyWith(
      selectedTripLeg2: trip,
      selectedClassLeg2: coachClass,
      selectedSeatsLeg2: const [], // reset
      currentStep: IndirectBookingStep.seatLeg1,
    ));
  }

  void saveSeatsLeg2(List<String> seats) {
    final requiredCount = state.selectedSeatsLeg1.length;
    if (requiredCount == 0 || seats.length != requiredCount) {
      // Ignored for UI, but the UI should prevent proceeding if not equal
      return; 
    }
    emit(state.copyWith(
      selectedSeatsLeg2: seats,
      currentStep: IndirectBookingStep.summary,
    ));
  }

  // Reset or Back Actions
  void goBackToLeg1Search() {
    emit(state.copyWith(currentStep: IndirectBookingStep.searchLeg1));
  }
  
  void goBackToLeg1Seats() {
    emit(state.copyWith(currentStep: IndirectBookingStep.seatLeg1));
  }

  void goBackToLeg2Search() {
    emit(state.copyWith(currentStep: IndirectBookingStep.searchLeg2));
  }

  void clearLeg2Selection() {
    // Return completely back to changing Leg 2 Date / Choice, preserving Leg 1
    emit(state.copyWith(
      selectedSeatsLeg2: const [],
      clearLeg2Selection: true,
      currentStep: IndirectBookingStep.searchLeg2,
    ));
  }

  List<TripResultEntity> _applyTimeFilters(
    List<TripResultEntity> trips,
    SearchParams params,
  ) {
    if (!params.hasTimeFilters) return trips;

    return trips.where((t) {
      if (params.departureFrom != null || params.departureTo != null) {
        final depMins = _minsFromDateTime(t.departureTime);
        if (params.departureFrom != null &&
            depMins < _mins(params.departureFrom!)) {
          return false;
        }
        if (params.departureTo != null &&
            depMins > _mins(params.departureTo!)) {
          return false;
        }
      }
      if (params.arrivalFrom != null || params.arrivalTo != null) {
        if (t.arrivalTime == null) return false;
        final arrMins = _minsFromDateTime(t.arrivalTime!);
        if (params.arrivalFrom != null &&
            arrMins < _mins(params.arrivalFrom!)) {
          return false;
        }
        if (params.arrivalTo != null && arrMins > _mins(params.arrivalTo!)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  int _mins(TimeOfDay t) => t.hour * 60 + t.minute;
  int _minsFromDateTime(DateTime t) => t.hour * 60 + t.minute;
}
