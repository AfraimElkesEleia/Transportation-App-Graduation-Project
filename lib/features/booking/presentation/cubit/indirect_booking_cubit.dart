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
        leg1Results: paged.items,
        leg1CurrentPage: paged.currentPage,
        leg1TotalPages: paged.totalPages,
      )),
    );
  }

  Future<void> loadMoreLeg1() async {
    if (isClosed) return;
    if (state.isFetchingMoreLeg1 || !state.hasMoreLeg1Pages) return;

    emit(state.copyWith(isFetchingMoreLeg1: true));

    // The previous request params are the same as newParams above, but with pageNumber + 1.
    final nextPage = state.leg1CurrentPage + 1;
    final newParams = SearchParams(
      fromStationId: state.leg1Results!.first.originStationId,
      toStationId: state.leg1Results!.first.destinationStationId,
      fromDisplayName: "", // Not strictly used by API, only by UI
      toDisplayName: "", // Not strictly used by API
      travelDate: state.leg1Results!.first.departureTime.toIso8601String().split('T').first,
      passengers: state.requiredSeatCount,
      transport: state.activeParams?.transport ?? TransportType.all,
      sortBy: state.activeParams?.sortBy ?? SortBy.departureTime,
      maxPrice: state.activeParams?.maxPrice,
      preferredAgencies: state.activeParams?.preferredAgencies ?? const [],
      departureFrom: state.activeParams?.departureFrom,
      departureTo: state.activeParams?.departureTo,
      arrivalFrom: state.activeParams?.arrivalFrom,
      arrivalTo: state.activeParams?.arrivalTo,
      pageNumber: nextPage,
    );

    final result = await searchTripsUseCase(newParams);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(isFetchingMoreLeg1: false)),
      (paged) {
        final existingIds = state.leg1Results!.map((t) => t.tripOccurrenceId).toSet();
        final newItems = paged.items.where((t) => !existingIds.contains(t.tripOccurrenceId)).toList();
        
        emit(state.copyWith(
          isFetchingMoreLeg1: false,
          leg1Results: [...state.leg1Results!, ...newItems],
          leg1CurrentPage: paged.currentPage,
          leg1TotalPages: paged.totalPages,
        ));
      },
    );
  }

  void selectTripLeg1(TripResultEntity trip, CoachClassEntity coachClass) {
    emit(state.copyWith(
      selectedTripLeg1: trip,
      selectedClassLeg1: coachClass,
      selectedSeatsLeg1: const [], // reset
      currentStep: IndirectBookingStep.seatLeg1,
    ));
  }

  void saveSeatsLeg1(List<String> seats) {
    emit(state.copyWith(
      selectedSeatsLeg1: seats,
      currentStep: IndirectBookingStep.searchLeg2,
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
  }) async {
    emit(state.copyWith(
      isLoadingLeg2: true,
      clearLeg2Error: true,
      leg2Results: [],
    ));

    final newParams = SearchParams(
      fromStationId: fromStationId,
      toStationId: toStationId,
      fromDisplayName: fromDisplayName,
      toDisplayName: toDisplayName,
      travelDate: date.toIso8601String().split('T').first,
      passengers: state.requiredSeatCount,
      transport: state.activeParams?.transport ?? TransportType.all,
      sortBy: state.activeParams?.sortBy ?? SortBy.departureTime,
      maxPrice: state.activeParams?.maxPrice,
      preferredAgencies: state.activeParams?.preferredAgencies ?? const [],
      departureFrom: state.activeParams?.departureFrom,
      departureTo: state.activeParams?.departureTo,
      arrivalFrom: state.activeParams?.arrivalFrom,
      arrivalTo: state.activeParams?.arrivalTo,
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

        final validTrips = paged.items.where((t) {
          return t.departureTime.isAfter(safeDepartureTime);
        }).toList();

        emit(state.copyWith(
          isLoadingLeg2: false,
          leg2Results: validTrips,
          leg2CurrentPage: paged.currentPage,
          leg2TotalPages: paged.totalPages,
        ));
      },
    );
  }

  Future<void> loadMoreLeg2(DateTime leg1ArrivalTime) async {
    if (isClosed) return;
    if (state.isFetchingMoreLeg2 || !state.hasMoreLeg2Pages) return;

    emit(state.copyWith(isFetchingMoreLeg2: true));

    final nextPage = state.leg2CurrentPage + 1;
    final newParams = SearchParams(
      fromStationId: state.leg2Results!.first.originStationId,
      toStationId: state.leg2Results!.first.destinationStationId,
      fromDisplayName: "", 
      toDisplayName: "", 
      travelDate: state.leg2Results!.first.departureTime.toIso8601String().split('T').first,
      passengers: state.requiredSeatCount,
      transport: state.activeParams?.transport ?? TransportType.all,
      sortBy: state.activeParams?.sortBy ?? SortBy.departureTime,
      maxPrice: state.activeParams?.maxPrice,
      preferredAgencies: state.activeParams?.preferredAgencies ?? const [],
      departureFrom: state.activeParams?.departureFrom,
      departureTo: state.activeParams?.departureTo,
      arrivalFrom: state.activeParams?.arrivalFrom,
      arrivalTo: state.activeParams?.arrivalTo,
      pageNumber: nextPage,
    );

    final result = await searchTripsUseCase(newParams);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(isFetchingMoreLeg2: false)),
      (paged) {
        final existingIds = state.leg2Results!.map((t) => t.tripOccurrenceId).toSet();
        
        final safeDepartureTime = leg1ArrivalTime.add(const Duration(minutes: 60));
        
        final newItems = paged.items.where((t) {
          if (existingIds.contains(t.tripOccurrenceId)) return false;
          return t.departureTime.isAfter(safeDepartureTime);
        }).toList();
        
        emit(state.copyWith(
          isFetchingMoreLeg2: false,
          leg2Results: [...state.leg2Results!, ...newItems],
          leg2CurrentPage: paged.currentPage,
          leg2TotalPages: paged.totalPages,
        ));
      },
    );
  }

  void selectTripLeg2(TripResultEntity trip, CoachClassEntity coachClass) {
    emit(state.copyWith(
      selectedTripLeg2: trip,
      selectedClassLeg2: coachClass,
      selectedSeatsLeg2: const [], // reset
      currentStep: IndirectBookingStep.seatLeg2,
    ));
  }

  void saveSeatsLeg2(List<String> seats) {
    // Validate count matches leg 1
    if (seats.length != state.requiredSeatCount) {
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

  void clearLeg2Selection() {
    // Return completely back to changing Leg 2 Date / Choice, preserving Leg 1
    emit(state.copyWith(
      selectedTripLeg2: null,
      selectedClassLeg2: null,
      selectedSeatsLeg2: const [],
      currentStep: IndirectBookingStep.searchLeg2,
    ));
  }
}
