import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/domain/usecases/search_trips_usecase.dart';
import 'package:transportation_app/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:transportation_app/features/booking/presentation/cubit/round_trip_booking_state.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';
import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';

class RoundTripBookingCubit extends Cubit<RoundTripBookingState> {
  final SearchTripsUseCase searchTripsUseCase;
  final BookingRemoteDatasource bookingRemoteDatasource;

  RoundTripBookingCubit({
    required this.searchTripsUseCase,
    required this.bookingRemoteDatasource,
  }) : super(const RoundTripBookingState());

  void setStep(RoundTripBookingStep step) {
    emit(state.copyWith(currentStep: step));
  }

  // ── Outbound ──
  Future<void> searchOutbound(SearchParams params) async {
    emit(
      state.copyWith(
        activeParams: params,
        isLoadingOutbound: true,
        clearOutboundError: true,
        outboundResults: [],
      ),
    );

    final result = await searchTripsUseCase(params);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingOutbound: false,
          outboundError: failure.message,
        ),
      ),
      (paged) => emit(
        state.copyWith(
          isLoadingOutbound: false,
          outboundResults: paged.items,
          outboundCurrentPage: paged.currentPage,
          outboundTotalPages: paged.totalPages,
        ),
      ),
    );
  }

  Future<void> loadMoreOutbound() async {
    if (isClosed ||
        state.isFetchingMoreOutbound ||
        !state.hasMoreOutboundPages) {
      return;
    }

    emit(state.copyWith(isFetchingMoreOutbound: true));

    final newParams = state.activeParams!.copyWith(
      newPage: state.outboundCurrentPage + 1,
    );
    final result = await searchTripsUseCase(newParams);

    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(isFetchingMoreOutbound: false)),
      (paged) {
        final existingIds = state.outboundResults!
            .map((t) => t.tripOccurrenceId)
            .toSet();
        final newItems = paged.items
            .where((t) => !existingIds.contains(t.tripOccurrenceId))
            .toList();

        emit(
          state.copyWith(
            isFetchingMoreOutbound: false,
            outboundResults: [...state.outboundResults!, ...newItems],
            outboundCurrentPage: paged.currentPage,
            outboundTotalPages: paged.totalPages,
          ),
        );
      },
    );
  }

  void selectOutboundTrip(TripResultEntity trip, CoachClassEntity coachClass) {
    emit(
      state.copyWith(
        selectedOutboundTrip: trip,
        selectedOutboundClass: coachClass,
        currentStep: RoundTripBookingStep.searchReturn,
      ),
    );
    _searchReturnForSelectedOutbound();
  }

  void applyOutboundFilters(SearchParams newParams) {
    searchOutbound(newParams);
  }

  void applyReturnFilters(SearchParams newParams) {
    emit(
      state.copyWith(
        activeParams: state.activeParams!.copyWith(
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
        ),
      ),
    );
    _searchReturnForSelectedOutbound();
  }

  // ── Return ──
  Future<void> _searchReturnForSelectedOutbound() async {
    if (state.activeParams?.returnDate == null ||
        state.selectedOutboundTrip == null) {
      emit(
        state.copyWith(returnError: 'Return date or outbound trip missing.'),
      );
      return;
    }

    emit(
      state.copyWith(
        isLoadingReturn: true,
        clearReturnError: true,
        returnResults: [],
      ),
    );

    final returnParams = state.activeParams!.copyWith(
      travelDate: state.activeParams!.returnDate, // use return date
      newPage: 1,
    );

    final swappedParams = SearchParams(
      isRoundTrip: false,
      travelDate: returnParams.travelDate,
      passengers: returnParams.passengers,
      fromStationId: returnParams.toStationId,
      toStationId: returnParams.fromStationId,
      fromGovernorate: returnParams.toGovernorate,
      toGovernorate: returnParams.fromGovernorate,
      fromDisplayName: returnParams.toDisplayName,
      toDisplayName: returnParams.fromDisplayName,
      transport: returnParams.transport,
      sortBy: returnParams.sortBy,
      maxPrice: returnParams.maxPrice,
      preferredAgencies: returnParams.preferredAgencies,
      departureFrom: returnParams.departureFrom,
      departureTo: returnParams.departureTo,
      arrivalFrom: returnParams.arrivalFrom,
      arrivalTo: returnParams.arrivalTo,
    );

    final result = await searchTripsUseCase(swappedParams);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingReturn: false, returnError: failure.message),
      ),
      (paged) {
        emit(
          state.copyWith(
            isLoadingReturn: false,
            returnResults: paged.items,
            returnCurrentPage: paged.currentPage,
            returnTotalPages: paged.totalPages,
          ),
        );
      },
    );
  }

  Future<void> loadMoreReturn() async {
    if (isClosed ||
        state.isFetchingMoreReturn ||
        !state.hasMoreReturnPages ||
        state.selectedOutboundTrip == null) {
      return;
    }

    emit(state.copyWith(isFetchingMoreReturn: true));

    final returnParams = state.activeParams!.copyWith(
      travelDate: state.activeParams!.returnDate,
      newPage: state.returnCurrentPage + 1,
    );

    final swappedParams = SearchParams(
      isRoundTrip: false,
      travelDate: returnParams.travelDate,
      passengers: returnParams.passengers,
      fromStationId: returnParams.toStationId,
      toStationId: returnParams.fromStationId,
      fromGovernorate: returnParams.toGovernorate,
      toGovernorate: returnParams.fromGovernorate,
      fromDisplayName: returnParams.toDisplayName,
      toDisplayName: returnParams.fromDisplayName,
      transport: returnParams.transport,
      sortBy: returnParams.sortBy,
      pageNumber: returnParams.pageNumber,
      maxPrice: returnParams.maxPrice,
      preferredAgencies: returnParams.preferredAgencies,
      departureFrom: returnParams.departureFrom,
      departureTo: returnParams.departureTo,
      arrivalFrom: returnParams.arrivalFrom,
      arrivalTo: returnParams.arrivalTo,
    );

    final result = await searchTripsUseCase(swappedParams);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(isFetchingMoreReturn: false)),
      (paged) {
        final existingIds = state.returnResults!
            .map((t) => t.tripOccurrenceId)
            .toSet();
        final newItems = paged.items.where((t) {
          if (existingIds.contains(t.tripOccurrenceId)) return false;
          return true;
        }).toList();

        emit(
          state.copyWith(
            isFetchingMoreReturn: false,
            returnResults: [...state.returnResults!, ...newItems],
            returnCurrentPage: paged.currentPage,
            returnTotalPages: paged.totalPages,
          ),
        );
      },
    );
  }

  void selectReturnTrip(TripResultEntity trip, CoachClassEntity coachClass) {
    emit(
      state.copyWith(
        selectedReturnTrip: trip,
        selectedReturnClass: coachClass,
        currentStep: RoundTripBookingStep.selectSeats,
      ),
    );
  }

  void saveUnifiedSeats(List<String> outboundSeats, List<String> returnSeats) {
    // Each leg only needs at least one seat — counts can differ.
    if (outboundSeats.isEmpty || returnSeats.isEmpty) return;
    emit(
      state.copyWith(
        selectedOutboundSeats: outboundSeats,
        selectedReturnSeats: returnSeats,
        currentStep: RoundTripBookingStep.summary,
      ),
    );
  }

  // ── Cart / Bundle Submission ──
  Future<void> submitRoundTrip({
    required String contactName,
    required String contactPhone,
    required String contactEmail,
    required List<Map<String, dynamic>> outboundPassengers,
    required List<Map<String, dynamic>> returnPassengers,
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
      final outboundPayload = {
        'tripOccurrenceId': state.selectedOutboundTrip!.tripOccurrenceId,
        'coachClassId': state.selectedOutboundClass!.coachClassId,
        'originStationId': state.selectedOutboundTrip!.originStationId,
        'destinationStationId':
            state.selectedOutboundTrip!.destinationStationId,
        'contactName': contactName,
        'contactPhone': contactPhone,
        'contactEmail': contactEmail,
        'passengers': outboundPassengers,
      };

      final returnPayload = {
        'tripOccurrenceId': state.selectedReturnTrip!.tripOccurrenceId,
        'coachClassId': state.selectedReturnClass!.coachClassId,
        'originStationId': state.selectedReturnTrip!.originStationId,
        'destinationStationId': state.selectedReturnTrip!.destinationStationId,
        'contactName': contactName,
        'contactPhone': contactPhone,
        'contactEmail': contactEmail,
        'passengers': returnPassengers,
      };

      // 1. Add Outbound
      await bookingRemoteDatasource.addToCart(outboundPayload);
      if (isClosed) return;

      try {
        // 2. Add Return
        await bookingRemoteDatasource.addToCart(returnPayload);
        if (isClosed) return;
        emit(state.copyWith(isAddingToCart: false, cartSuccess: true));
      } catch (e) {
        if (isClosed) return;
        // Leg 2 failed -> Rollback attempt
        // Currently API might not support an explicit rollback for a specific item easily
        // We will do a generic clear cart or just instruct the user.
        emit(
          state.copyWith(
            isAddingToCart: false,
            cartSuccess: true,
            cartError:
                'Sorry, the return trip seats are no longer available. Please select a different return trip. (Note: Outbound trip was added to cart)',
          ),
        );
      }
    } catch (e) {
      if (isClosed) return;
      // Outbound failed
      emit(state.copyWith(isAddingToCart: false, cartError: e.toString()));
    }
  }

  Future<void> bookNowRoundTrip({
    required String contactName,
    required String contactPhone,
    required String contactEmail,
    required List<Map<String, dynamic>> outboundPassengers,
    required List<Map<String, dynamic>> returnPassengers,
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
      final outboundPayload = {
        'tripOccurrenceId': state.selectedOutboundTrip!.tripOccurrenceId,
        'coachClassId': state.selectedOutboundClass!.coachClassId,
        'originStationId': state.selectedOutboundTrip!.originStationId,
        'destinationStationId':
            state.selectedOutboundTrip!.destinationStationId,
        'contactName': contactName,
        'contactPhone': contactPhone,
        'contactEmail': contactEmail,
        'passengers': outboundPassengers,
      };

      final returnPayload = {
        'tripOccurrenceId': state.selectedReturnTrip!.tripOccurrenceId,
        'coachClassId': state.selectedReturnClass!.coachClassId,
        'originStationId': state.selectedReturnTrip!.originStationId,
        'destinationStationId': state.selectedReturnTrip!.destinationStationId,
        'contactName': contactName,
        'contactPhone': contactPhone,
        'contactEmail': contactEmail,
        'passengers': returnPassengers,
      };

      // 1. Add Outbound to Cart
      await bookingRemoteDatasource.addToCart(outboundPayload);
      if (isClosed) return;

      try {
        // 2. Add Return to Cart
        await bookingRemoteDatasource.addToCart(returnPayload);
        if (isClosed) return;

        // 3. Checkout
        await bookingRemoteDatasource.checkout(pointsToRedeem: pointsToRedeem);
        if (isClosed) return;
        emit(state.copyWith(isBookingNow: false, checkoutSuccess: true));
      } catch (e) {
        if (isClosed) return;
        // Leg 2 or Checkout failed
        emit(
          state.copyWith(
            isBookingNow: false,
            cartSuccess: true,
            cartError: 'Failed to complete booking: ${e.toString()}',
          ),
        );
      }
    } catch (e) {
      if (isClosed) return;
      // Outbound failed
      emit(state.copyWith(isBookingNow: false, cartError: e.toString()));
    }
  }

  // ── Navigation ──
  void goBackToOutbound() {
    emit(
      state.copyWith(
        currentStep: RoundTripBookingStep.searchOutbound,
        clearOutboundSelection: true,
        clearReturnSelection: true,
        selectedOutboundSeats: const [],
        selectedReturnSeats: const [],
      ),
    );
  }

  void goBackToReturn() {
    emit(
      state.copyWith(
        currentStep: RoundTripBookingStep.searchReturn,
        clearReturnSelection: true,
        selectedOutboundSeats: const [],
        selectedReturnSeats: const [],
      ),
    );
  }

  void goBackToSeats() {
    emit(state.copyWith(currentStep: RoundTripBookingStep.selectSeats));
  }
}
