import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';
import 'package:transportation_app/features/search/domain/entities/recent_search_entity.dart';
import 'package:transportation_app/features/search/domain/usecases/save_recent_search_usecase.dart';
import 'package:transportation_app/features/search/domain/usecases/search_indirect_trips_usecase.dart';
import 'package:transportation_app/features/search/domain/usecases/search_trips_usecase.dart';
import 'package:transportation_app/features/search/presentation/cubit/search_states.dart';
import 'package:uuid/uuid.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchTripsUseCase searchTripsUseCase;
  final SearchIndirectTripsUseCase searchIndirectTripsUseCase;
  final SaveRecentSearchUseCase saveRecentSearchUseCase;

  SearchCubit({
    required this.searchTripsUseCase,
    required this.searchIndirectTripsUseCase,
    required this.saveRecentSearchUseCase,
  }) : super(SearchInitial());

  Future<void> search(SearchParams params) async {
    if (isClosed) return;
    emit(SearchLoading());
    final firstPageParams = params.copyWith(newPage: 1);
    
    // Save to recent searches
    _saveToRecentSearches(firstPageParams);
    
    final result = await searchTripsUseCase(firstPageParams);
    if (isClosed) return;

    result.fold((failure) => emit(SearchError(failure.message)), (paged) {
      // Apply client-side time filters
      final filtered = _applyTimeFilters(paged.items, firstPageParams);

      emit(
        SearchLoaded(
          directItems: filtered,
          unfilteredDirectItems: paged.items,
          directCurrentPage: paged.currentPage,
          directTotalPages: paged.totalPages,
          activeParams: firstPageParams,
        ),
      );
    });
  }

  Future<void> loadMoreDirectTrips() async {
    if (isClosed) return;
    final current = state;
    if (current is! SearchLoaded) return;
    if (current.isFetchingMoreDirect) return; // already loading
    if (!current.hasMoreDirectPages) return; // no more pages

    // Show bottom spinner
    emit(current.copyWith(isFetchingMoreDirect: true));

    final nextPage = current.directCurrentPage + 1;
    final nextParams = current.activeParams.copyWith(newPage: nextPage);
    if (kDebugMode) {
      debugPrint(
        '[SearchCubit] loadMoreDirect current=${current.directCurrentPage} '
        'next=$nextPage total=${current.directTotalPages} '
        'visible=${current.directItems.length} '
        'loaded=${current.unfilteredDirectItems.length}',
      );
    }
    final result = await searchTripsUseCase(nextParams);
    if (isClosed) return;

    result.fold(
      (failure) {
        // Hide spinner — don't break the existing list
        emit(current.copyWith(isFetchingMoreDirect: false));
      },
      (paged) {
        if (kDebugMode) {
          debugPrint(
            '[SearchCubit] loaded direct page=${paged.currentPage}/'
            '${paged.totalPages} totalCount=${paged.totalCount} '
            'pageSize=${paged.pageSize} items=${paged.items.length}',
          );
        }
        // Deduplicate by tripOccurrenceId before appending
        final existingIds = current.unfilteredDirectItems
            .map((t) => t.tripOccurrenceId)
            .toSet();
        final newItems = paged.items
            .where((t) => !existingIds.contains(t.tripOccurrenceId))
            .toList();

        final unfilteredCombined = [
          ...current.unfilteredDirectItems,
          ...newItems,
        ];
        final visibleCombined = _applyTimeFilters(
          unfilteredCombined,
          current.activeParams,
        );

        emit(
          current.copyWith(
            directItems: visibleCombined,
            unfilteredDirectItems: unfilteredCombined,
            directCurrentPage: paged.currentPage,
            directTotalPages: paged.totalPages,
            isFetchingMoreDirect: false,
            activeParams: nextParams,
          ),
        );
      },
    );
  }

  Future<void> searchIndirect() async {
    if (isClosed) return;
    final current = state;
    if (current is! SearchLoaded) return;
    if (current.indirectSearched) return; // never call again

    emit(
      current.copyWith(
        indirectSearched: true,
        indirectLoading: true,
        clearIndirectError: true,
      ),
    );

    final firstPageParams = current.activeParams.copyWith(newPage: 1);
    final result = await searchIndirectTripsUseCase(firstPageParams);
    if (isClosed) return;
    final latestState = state as SearchLoaded;
    result.fold(
      (failure) => emit(
        latestState.copyWith(
          indirectLoading: false,
          indirectError: failure.message,
        ),
      ),
      (paged) {
        emit(
          latestState.copyWith(
            indirectItems: paged.items,
            indirectCurrentPage: paged.currentPage,
            indirectTotalPages: paged.totalPages,
            indirectLoading: false,
          ),
        );
      },
    );
  }

  Future<void> loadMoreIndirectTrips() async {
    if (isClosed) return;
    final current = state;
    if (current is! SearchLoaded) return;
    if (current.isFetchingMoreIndirect) return;
    if (!current.hasMoreIndirectPages) return;

    emit(current.copyWith(isFetchingMoreIndirect: true));

    final nextPage = current.indirectCurrentPage + 1;
    final nextParams = current.activeParams.copyWith(newPage: nextPage);
    final result = await searchIndirectTripsUseCase(nextParams);
    if (isClosed) return;

    result.fold(
      (failure) => emit(current.copyWith(isFetchingMoreIndirect: false)),
      (paged) {
        // Deduplicate
        final existingIds = current.indirectItems
            .map(
              (t) =>
                  '${t.firstLeg.tripOccurrenceId}_${t.secondLeg.tripOccurrenceId}',
            )
            .toSet();
        final newItems = paged.items
            .where(
              (t) => !existingIds.contains(
                '${t.firstLeg.tripOccurrenceId}_${t.secondLeg.tripOccurrenceId}',
              ),
            )
            .toList();

        emit(
          current.copyWith(
            indirectItems: [...current.indirectItems, ...newItems],
            indirectCurrentPage: paged.currentPage,
            indirectTotalPages: paged.totalPages,
            isFetchingMoreIndirect: false,
          ),
        );
      },
    );
  }

  Future<void> applyFilters(SearchParams newParams) async {
    if (isClosed) return;
    final current = state;
    if (current is! SearchLoaded) return;

    final serverParamsChanged =
        newParams.sortBy != current.activeParams.sortBy ||
        newParams.transport != current.activeParams.transport ||
        newParams.maxPrice != current.activeParams.maxPrice ||
        !_sameAgencies(
          newParams.preferredAgencies,
          current.activeParams.preferredAgencies,
        );

    if (serverParamsChanged) {
      // ── Full reset — new server query from page 1 ──────────
      // We do NOT call search() here to avoid emitting SearchLoading
      // which would cause a full-screen flash. Instead emit a fresh
      // SearchLoaded state while keeping the old list visible briefly.
      if (!isClosed) emit(SearchLoading());
      await search(newParams.copyWith(newPage: 1));
    } else {
      // ── Time filter only — filter current in-memory list ───
      final filtered = _applyTimeFilters(
        current.unfilteredDirectItems,
        newParams,
      );
      emit(current.copyWith(directItems: filtered, activeParams: newParams));
      // Note: we filter the already-accumulated unfilteredDirectItems.
      // When user loads more pages, new items also get filtered via loadMore.
    }
  }

  List<TripResultEntity> _applyTimeFilters(
    List<TripResultEntity> trips,
    SearchParams params,
  ) {
    if (!params.hasTimeFilters) return trips;

    return trips.where((t) {
      // Departure range
      if (params.departureFrom != null || params.departureTo != null) {
        final dep = TimeOfDay.fromDateTime(t.departureTime);
        final depMins = _mins(dep);
        if (params.departureFrom != null &&
            depMins < _mins(params.departureFrom!)) {
          return false;
        }
        if (params.departureTo != null && depMins > _mins(params.departureTo!)) {
          return false;
        }
      }
      // Arrival range
      if (params.arrivalFrom != null || params.arrivalTo != null) {
        if (t.arrivalTime == null) return false;
        final arr = TimeOfDay.fromDateTime(t.arrivalTime!);
        final arrMins = _mins(arr);
        if (params.arrivalFrom != null && arrMins < _mins(params.arrivalFrom!)) {
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

  bool _sameAgencies(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Future<void> _saveToRecentSearches(SearchParams params) async {
    try {
      final recentSearch = RecentSearchEntity(
        id: const Uuid().v4(),
        fromDisplayName: params.fromDisplayName,
        toDisplayName: params.toDisplayName,
        fromGovernorate: params.fromGovernorate,
        fromStationId: params.fromStationId,
        toGovernorate: params.toGovernorate,
        toStationId: params.toStationId,
        travelDate: params.travelDate,
        isRoundTrip: params.isRoundTrip,
        returnDate: params.returnDate,
        passengers: params.passengers,
        createdAt: DateTime.now(),
      );
      await saveRecentSearchUseCase(recentSearch);
    } catch (e) {
      debugPrint('Failed to save recent search: $e');
    }
  }
}
