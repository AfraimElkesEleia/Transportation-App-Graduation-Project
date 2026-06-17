import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/features/booking/domain/usecases/add_to_cart_usecase.dart';
import 'package:transportation_app/features/booking/domain/usecases/checkout_usecase.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/domain/usecases/search_trips_usecase.dart';
import 'package:transportation_app/features/multidestination/presentation/cubit/multi_destination_booking_state.dart';
import 'package:transportation_app/features/multidestination/presentation/screens/multidestination_summary_screen.dart';
import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';

class MultiDestinationBookingCubit extends Cubit<MultiDestinationBookingState> {
  final SearchTripsUseCase searchTripsUseCase;
  final AddToCartUseCase addToCartUseCase;
  final CheckoutUseCase checkoutUseCase;

  MultiDestinationBookingCubit({
    required List<MultiDestinationLegSummary> legs,
    required this.searchTripsUseCase,
    required this.addToCartUseCase,
    required this.checkoutUseCase,
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

    emit(
      state.copyWith(
        isSearching: true,
        clearSearchError: true,
        searchResults: [],
        unfilteredSearchResults: [],
        currentActiveParams: params,
      ),
    );

    final result = await searchTripsUseCase(params);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(isSearching: false, searchError: failure.message),
      ),
      (paged) => emit(
        state.copyWith(
          isSearching: false,
          searchResults: _applyTimeFilters(paged.items, params),
          unfilteredSearchResults: paged.items,
          currentPage: paged.currentPage,
          totalPages: paged.totalPages,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    if (isClosed ||
        state.isFetchingMore ||
        state.currentPage >= state.totalPages) {
      return;
    }

    emit(state.copyWith(isFetchingMore: true));
    final nextParams = state.currentActiveParams!.copyWith(
      newPage: state.currentPage + 1,
    );
    final result = await searchTripsUseCase(nextParams);
    if (isClosed) return;

    result.fold((f) => emit(state.copyWith(isFetchingMore: false)), (paged) {
      final unfiltered = state.unfilteredSearchResults ?? const [];
      final existingIds = unfiltered
          .map((t) => t.tripOccurrenceId)
          .toSet();
      final newItems = paged.items
          .where((t) => !existingIds.contains(t.tripOccurrenceId))
          .toList();
      final unfilteredCombined = [...unfiltered, ...newItems];

      emit(
        state.copyWith(
          isFetchingMore: false,
          searchResults: _applyTimeFilters(
            unfilteredCombined,
            state.currentActiveParams!,
          ),
          unfilteredSearchResults: unfilteredCombined,
          currentPage: paged.currentPage,
          totalPages: paged.totalPages,
        ),
      );
    });
  }

  void applyFilters(SearchParams newParams) {
    emit(
      state.copyWith(
        currentActiveParams: state.currentActiveParams!.copyWith(
          transport: newParams.transport,
          sortBy: newParams.sortBy,
          maxPrice: newParams.maxPrice,
          clearMaxPrice: newParams.maxPrice == null,
          preferredAgencies: newParams.preferredAgencies,
          departureFrom: newParams.departureFrom,
          departureTo: newParams.departureTo,
          arrivalFrom: newParams.arrivalFrom,
          arrivalTo: newParams.arrivalTo,
          clearTimeFilters: !newParams.hasTimeFilters,
          newPage: 1,
        ),
      ),
    );
    _searchCurrentLeg();
  }

  void selectTripForLeg(TripResultEntity trip, CoachClassEntity coachClass) {
    final updatedTrips = Map<int, TripResultEntity>.from(state.selectedTrips);
    final updatedClasses = Map<int, CoachClassEntity>.from(
      state.selectedClasses,
    );

    updatedTrips[state.currentSearchLegIndex] = trip;
    updatedClasses[state.currentSearchLegIndex] = coachClass;

    if (state.currentSearchLegIndex < state.legSummaries.length - 1) {
      emit(
        state.copyWith(
          selectedTrips: updatedTrips,
          selectedClasses: updatedClasses,
          currentSearchLegIndex: state.currentSearchLegIndex + 1,
        ),
      );
      _searchCurrentLeg();
    } else {
      emit(
        state.copyWith(
          selectedTrips: updatedTrips,
          selectedClasses: updatedClasses,
          currentStep: MultiDestinationBookingStep.selectSeats,
          currentSeatLegIndex: 0,
        ),
      );
    }
  }

  void saveSeatsForCurrentLeg(List<String> seats) {
    if (seats.isEmpty) return;

    final updatedSeats = Map<int, List<String>>.from(state.selectedSeats);
    updatedSeats[state.currentSeatLegIndex] = seats;

    if (state.currentSeatLegIndex < state.legSummaries.length - 1) {
      emit(
        state.copyWith(
          selectedSeats: updatedSeats,
          currentSeatLegIndex: state.currentSeatLegIndex + 1,
        ),
      );
    } else {
      emit(
        state.copyWith(
          selectedSeats: updatedSeats,
          currentStep: MultiDestinationBookingStep.summary,
        ),
      );
    }
  }

  void goBack() {
    if (state.currentStep == MultiDestinationBookingStep.summary) {
      emit(
        state.copyWith(
          currentStep: MultiDestinationBookingStep.selectSeats,
          currentSeatLegIndex: state.legSummaries.length - 1,
        ),
      );
    } else if (state.currentStep == MultiDestinationBookingStep.selectSeats) {
      if (state.currentSeatLegIndex > 0) {
        emit(
          state.copyWith(currentSeatLegIndex: state.currentSeatLegIndex - 1),
        );
      } else {
        emit(
          state.copyWith(
            currentStep: MultiDestinationBookingStep.searchLegs,
            currentSearchLegIndex: state.legSummaries.length - 1,
          ),
        );
        _searchCurrentLeg(); // Re-search the last leg
      }
    } else if (state.currentStep == MultiDestinationBookingStep.searchLegs) {
      if (state.currentSearchLegIndex > 0) {
        emit(
          state.copyWith(
            currentSearchLegIndex: state.currentSearchLegIndex - 1,
          ),
        );
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
    emit(
      state.copyWith(
        isAddingToCart: true,
        clearCartError: true,
        cartSuccess: false,
        checkoutSuccess: false,
      ),
    );

    try {
      for (final payload in _buildPayloads(
        contactName: contactName,
        contactPhone: contactPhone,
        contactEmail: contactEmail,
        allPassengers: allPassengers,
      )) {
        final result = await addToCartUseCase(payload);
        if (isClosed) return;
        final failed = result.fold((failure) {
          emit(state.copyWith(isAddingToCart: false, cartError: failure.message));
          return true;
        }, (_) => false);
        if (failed) return;
      }
      emit(state.copyWith(isAddingToCart: false, cartSuccess: true));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isAddingToCart: false, cartError: e.toString()));
    }
  }

  Future<void> bookNow({
    required String contactName,
    required String contactPhone,
    required String contactEmail,
    required Map<int, List<Map<String, dynamic>>> allPassengers,
    required int pointsToRedeem,
  }) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        isBookingNow: true,
        clearCartError: true,
        cartSuccess: false,
        checkoutSuccess: false,
      ),
    );

    try {
      for (final payload in _buildPayloads(
        contactName: contactName,
        contactPhone: contactPhone,
        contactEmail: contactEmail,
        allPassengers: allPassengers,
      )) {
        final result = await addToCartUseCase(payload);
        if (isClosed) return;
        final failed = result.fold((failure) {
          emit(state.copyWith(isBookingNow: false, cartError: failure.message));
          return true;
        }, (_) => false);
        if (failed) return;
      }
      final checkoutResult = await checkoutUseCase(pointsToRedeem: pointsToRedeem);
      if (isClosed) return;
      checkoutResult.fold(
        (failure) => emit(
          state.copyWith(
            isBookingNow: false,
            cartSuccess: true,
            cartError: failure.message,
          ),
        ),
        (_) => emit(state.copyWith(isBookingNow: false, checkoutSuccess: true)),
      );
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isBookingNow: false, cartError: e.toString()));
    }
  }

  List<Map<String, dynamic>> _buildPayloads({
    required String contactName,
    required String contactPhone,
    required String contactEmail,
    required Map<int, List<Map<String, dynamic>>> allPassengers,
  }) {
    return List.generate(state.legSummaries.length, (i) {
      final trip = state.selectedTrips[i]!;
      final c = state.selectedClasses[i]!;
      final pass = allPassengers[i]!;

      return {
        'tripOccurrenceId': trip.tripOccurrenceId,
        'coachClassId': c.coachClassId,
        'originStationId': trip.originStationId,
        'destinationStationId': trip.destinationStationId,
        'contactName': contactName,
        'contactPhone': contactPhone,
        'contactEmail': contactEmail,
        'passengers': pass,
      };
    });
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
