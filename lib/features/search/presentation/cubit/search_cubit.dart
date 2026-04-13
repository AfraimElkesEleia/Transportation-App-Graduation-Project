import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/domain/entities/indirect_trips_enitity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';
import 'package:transportation_app/features/search/domain/usecases/search_indirect_trips_usecase.dart';
import 'package:transportation_app/features/search/domain/usecases/search_trips_usecase.dart';
import 'package:transportation_app/features/search/presentation/cubit/search_states.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchTripsUseCase searchTripsUseCase;
  final SearchIndirectTripsUseCase searchIndirectTripsUseCase;

  SearchCubit({
    required this.searchTripsUseCase,
    required this.searchIndirectTripsUseCase,
  }) : super(SearchInitial());

  Future<void> search(SearchParams params) async {
    emit(SearchLoading());

    // Both endpoints in parallel
    final results = await Future.wait([
      searchTripsUseCase(params),
      searchIndirectTripsUseCase(params),
    ]);

    final directResult = results[0];
    final indirectResult = results[1];

    if (directResult.isLeft() && indirectResult.isLeft()) {
      directResult.fold(
        (failure) => emit(SearchError(failure.message)),
        (_) {},
      );
      return;
    }

    final directTrips = directResult.fold(
      (_) => <TripResultEntity>[],
      (trips) => trips as List<TripResultEntity>,
    );
    final indirectTrips = indirectResult.fold(
      (_) => <IndirectTripEntity>[],
      (trips) => trips as List<IndirectTripEntity>,
    );

    final filtered = _applyClientFilters(
      directTrips: directTrips,
      indirectTrips: indirectTrips,
      params: params,
    );

    emit(
      SearchLoaded(
        directTrips: directTrips,
        indirectTrips: indirectTrips,
        filteredDirect: filtered.$1,
        filteredIndirect: filtered.$2,
        activeParams: params,
      ),
    );
  }

  Future<void> applyFilters(SearchParams newParams) async {
    final current = state;
    if (current is! SearchLoaded) return;

    final serverParamsChanged =
        newParams.sortBy != current.activeParams.sortBy ||
        newParams.transport != current.activeParams.transport ||
        newParams.maxPrice != current.activeParams.maxPrice ||
        newParams.preferredAgencies != current.activeParams.preferredAgencies;

    if (serverParamsChanged) {
      await search(newParams);
    } else {
      final filtered = _applyClientFilters(
        directTrips: current.directTrips,
        indirectTrips: current.indirectTrips,
        params: newParams,
      );
      emit(
        SearchLoaded(
          directTrips: current.directTrips,
          indirectTrips: current.indirectTrips,
          filteredDirect: filtered.$1,
          filteredIndirect: filtered.$2,
          activeParams: newParams,
        ),
      );
    }
  }

  (List<TripResultEntity>, List<IndirectTripEntity>) _applyClientFilters({
    required List<TripResultEntity> directTrips,
    required List<IndirectTripEntity> indirectTrips,
    required SearchParams params,
  }) {
    List<TripResultEntity> direct = directTrips;
    List<IndirectTripEntity> indirect = indirectTrips;

    if (params.departureFrom != null || params.departureTo != null) {
      direct = direct.where((t) {
        final dep = TimeOfDay.fromDateTime(t.departureTime);
        if (params.departureFrom != null &&
            _mins(dep) < _mins(params.departureFrom!))
          return false;
        if (params.departureTo != null &&
            _mins(dep) > _mins(params.departureTo!))
          return false;
        return true;
      }).toList();

      indirect = indirect.where((t) {
        final dep = TimeOfDay.fromDateTime(t.firstLeg.departureTime);
        if (params.departureFrom != null &&
            _mins(dep) < _mins(params.departureFrom!))
          return false;
        if (params.departureTo != null &&
            _mins(dep) > _mins(params.departureTo!))
          return false;
        return true;
      }).toList();
    }
    // ... inside _applyClientFilters ...

    if (params.arrivalFrom != null || params.arrivalTo != null) {
      direct = direct.where((t) {
        // FIX: If there is no arrival time, it can't match a time-range filter
        if (t.arrivalTime == null) return false;

        final arr = TimeOfDay.fromDateTime(
          t.arrivalTime!,
        ); // Added ! after check
        if (params.arrivalFrom != null &&
            _mins(arr) < _mins(params.arrivalFrom!))
          return false;
        if (params.arrivalTo != null && _mins(arr) > _mins(params.arrivalTo!))
          return false;
        return true;
      }).toList();

      indirect = indirect.where((t) {
        if (t.secondLeg.arrivalTime == null) return false;

        final arr = TimeOfDay.fromDateTime(t.secondLeg.arrivalTime!);
        if (params.arrivalFrom != null &&
            _mins(arr) < _mins(params.arrivalFrom!))
          return false;
        if (params.arrivalTo != null && _mins(arr) > _mins(params.arrivalTo!))
          return false;
        return true;
      }).toList();
    }
    return (direct, indirect);
  }

  int _mins(TimeOfDay t) => t.hour * 60 + t.minute;
}
