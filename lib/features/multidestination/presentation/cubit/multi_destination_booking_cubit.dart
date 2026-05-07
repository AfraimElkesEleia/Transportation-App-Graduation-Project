import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/domain/usecases/search_trips_usecase.dart';
import 'package:transportation_app/features/multidestination/presentation/cubit/multi_destination_booking_state.dart';
import 'package:transportation_app/features/multidestination/presentation/screens/multidestination_summary_screen.dart';
import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';

class MultiDestinationBookingCubit extends Cubit<MultiDestinationBookingState> {
  final SearchTripsUseCase searchTripsUseCase;
  final BookingRemoteDatasource bookingRemoteDatasource;

  MultiDestinationBookingCubit({
    required List<MultiDestinationLegSummary> legs,
    required this.searchTripsUseCase,
    required this.bookingRemoteDatasource,
  }) : super(MultiDestinationBookingState(legSummaries: legs));

  void startFlow() {
    _searchCurrentLeg();
  }

  Future<void> _searchCurrentLeg() async {
    final leg = state.legSummaries[state.currentSearchLegIndex];

    SearchParams params;

    // Reuse existing params if we are just refreshing/filtering the same leg
    if (state.currentActiveParams != null &&
        state.currentActiveParams!.travelDate == leg.apiDate &&
        state.currentActiveParams!.fromDisplayName == leg.from &&
        state.currentActiveParams!.toDisplayName == leg.to) {
      params = state.currentActiveParams!.copyWith(newPage: 1);
    } else {
      // Build fresh params for a new leg
      params = SearchParams(
        isRoundTrip: false,
        travelDate: leg.apiDate,
        passengers: 1,   
        fromDisplayName: leg.from,
        toDisplayName: leg.to,
        fromGovernorate: leg.from, 
        toGovernorate: leg.to,
      );
    }

    emit(state.copyWith(
      isSearching: true,
      clearSearchError: true,
      searchResults: [],
      currentActiveParams: params,
    ));

    final result = await searchTripsUseCase(params);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(isSearching: false, searchError: failure.message)),
      (paged) => emit(state.copyWith(
        isSearching: false,
        searchResults: paged.items,
        currentPage: paged.currentPage,
        totalPages: paged.totalPages,
      )),
    );
  }

  Future<void> loadMore() async {
    if (isClosed || state.isFetchingMore || state.currentPage >= state.totalPages) return;

    emit(state.copyWith(isFetchingMore: true));
    final nextParams = state.currentActiveParams!.copyWith(newPage: state.currentPage + 1);
    final result = await searchTripsUseCase(nextParams);
    if (isClosed) return;

    result.fold(
      (f) => emit(state.copyWith(isFetchingMore: false)),
      (paged) {
        final existingIds = state.searchResults!.map((t) => t.tripOccurrenceId).toSet();
        final newItems = paged.items.where((t) => !existingIds.contains(t.tripOccurrenceId)).toList();
        
        emit(state.copyWith(
          isFetchingMore: false,
          searchResults: [...state.searchResults!, ...newItems],
          currentPage: paged.currentPage,
          totalPages: paged.totalPages,
        ));
      },
    );
  }

  void applyFilters(SearchParams newParams) {
    emit(state.copyWith(
      currentActiveParams: state.currentActiveParams!.copyWith(
        transport: newParams.transport,
        sortBy: newParams.sortBy,
        maxPrice: newParams.maxPrice,
        clearMaxPrice: newParams.maxPrice == null,
        departureFrom: newParams.departureFrom,
        departureTo: newParams.departureTo,
        arrivalFrom: newParams.arrivalFrom,
        arrivalTo: newParams.arrivalTo,
        clearTimeFilters: !newParams.hasTimeFilters,
        newPage: 1,
      ),
    ));
    _searchCurrentLeg();
  }

  void selectTripForLeg(TripResultEntity trip, CoachClassEntity coachClass) {
    final updatedTrips = Map<int, TripResultEntity>.from(state.selectedTrips);
    final updatedClasses = Map<int, CoachClassEntity>.from(state.selectedClasses);
    
    updatedTrips[state.currentSearchLegIndex] = trip;
    updatedClasses[state.currentSearchLegIndex] = coachClass;

    if (state.currentSearchLegIndex < state.legSummaries.length - 1) {
      emit(state.copyWith(
        selectedTrips: updatedTrips,
        selectedClasses: updatedClasses,
        currentSearchLegIndex: state.currentSearchLegIndex + 1,
      ));
      _searchCurrentLeg();
    } else {
      emit(state.copyWith(
        selectedTrips: updatedTrips,
        selectedClasses: updatedClasses,
        currentStep: MultiDestinationBookingStep.selectSeats,
        currentSeatLegIndex: 0,
      ));
    }
  }

  void saveSeatsForCurrentLeg(List<String> seats) {
    if (seats.isEmpty) return;

    final updatedSeats = Map<int, List<String>>.from(state.selectedSeats);
    updatedSeats[state.currentSeatLegIndex] = seats;

    if (state.currentSeatLegIndex < state.legSummaries.length - 1) {
      emit(state.copyWith(
        selectedSeats: updatedSeats,
        currentSeatLegIndex: state.currentSeatLegIndex + 1,
      ));
    } else {
      emit(state.copyWith(
        selectedSeats: updatedSeats,
        currentStep: MultiDestinationBookingStep.summary,
      ));
    }
  }

  void goBack() {
    if (state.currentStep == MultiDestinationBookingStep.summary) {
      emit(state.copyWith(
        currentStep: MultiDestinationBookingStep.selectSeats,
        currentSeatLegIndex: state.legSummaries.length - 1,
      ));
    } else if (state.currentStep == MultiDestinationBookingStep.selectSeats) {
      if (state.currentSeatLegIndex > 0) {
        emit(state.copyWith(currentSeatLegIndex: state.currentSeatLegIndex - 1));
      } else {
        emit(state.copyWith(
          currentStep: MultiDestinationBookingStep.searchLegs,
          currentSearchLegIndex: state.legSummaries.length - 1,
        ));
        _searchCurrentLeg(); // Re-search the last leg
      }
    } else if (state.currentStep == MultiDestinationBookingStep.searchLegs) {
      if (state.currentSearchLegIndex > 0) {
        emit(state.copyWith(currentSearchLegIndex: state.currentSearchLegIndex - 1));
        _searchCurrentLeg();
      }
    }
  }

  Future<void> submitCart({
    required String contactName,
    required String contactPhone,
    required String contactEmail,
    required Map<int, List<Map<String, dynamic>>> allPassengers,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(isAddingToCart: true, clearCartError: true));

    try {
      for (int i = 0; i < state.legSummaries.length; i++) {
        final trip = state.selectedTrips[i]!;
        final c = state.selectedClasses[i]!;
        final pass = allPassengers[i]!;

        final payload = {
          'tripOccurrenceId': trip.tripOccurrenceId,
          'coachClassId': c.coachClassId,
          'originStationId': trip.originStationId,
          'destinationStationId': trip.destinationStationId,
          'contactName': contactName,
          'contactPhone': contactPhone,
          'contactEmail': contactEmail,
          'passengers': pass,
        };

        await bookingRemoteDatasource.addToCart(payload);
      }
      emit(state.copyWith(isAddingToCart: false, cartSuccess: true));
    } catch (e) {
      emit(state.copyWith(isAddingToCart: false, cartError: e.toString()));
    }
  }
}
