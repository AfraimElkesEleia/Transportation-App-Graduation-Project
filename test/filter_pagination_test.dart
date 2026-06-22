import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/features/home/domain/entities/page_result_entity.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/domain/entities/indirect_trips_enitity.dart';
import 'package:transportation_app/features/search/domain/entities/recent_search_entity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';
import 'package:transportation_app/features/search/domain/repository/recent_search_repository.dart';
import 'package:transportation_app/features/search/domain/repository/search_repository.dart';
import 'package:transportation_app/features/search/domain/usecases/save_recent_search_usecase.dart';
import 'package:transportation_app/features/search/domain/usecases/search_indirect_trips_usecase.dart';
import 'package:transportation_app/features/search/domain/usecases/search_trips_usecase.dart';
import 'package:transportation_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:transportation_app/features/search/presentation/cubit/search_states.dart';
import 'package:transportation_app/features/booking/presentation/cubit/indirect_booking_cubit.dart';

void main() {
  group('filter pagination', () {
    test('direct search loads later pages when first page is filtered out',
        () async {
      final repository = _FakeSearchRepository({
        1: [_trip(id: 1, departureHour: 7)],
        2: [_trip(id: 2, departureHour: 9)],
      });
      final cubit = SearchCubit(
        searchTripsUseCase: SearchTripsUseCase(repository),
        searchIndirectTripsUseCase: SearchIndirectTripsUseCase(repository),
        saveRecentSearchUseCase: SaveRecentSearchUseCase(
          _FakeRecentSearchRepository(),
        ),
      );

      final params = _params(
        departureFrom: const TimeOfDay(hour: 8, minute: 0),
      );

      await cubit.search(params);
      final firstState = cubit.state as SearchLoaded;
      expect(firstState.directItems, isEmpty);
      expect(firstState.hasMoreDirectPages, isTrue);

      await cubit.loadMoreDirectTrips();
      final loaded = cubit.state as SearchLoaded;

      expect(repository.requestedPages, [1, 2]);
      expect(loaded.directItems.map((t) => t.tripOccurrenceId), [2]);
      expect(loaded.unfilteredDirectItems.map((t) => t.tripOccurrenceId), [
        1,
        2,
      ]);
    });

    test('indirect leg pagination uses stored params when visible list is empty',
        () async {
      final repository = _FakeSearchRepository({
        1: [_trip(id: 1, departureHour: 7)],
        2: [_trip(id: 2, departureHour: 9)],
      });
      final cubit = IndirectBookingCubit(
        searchTripsUseCase: SearchTripsUseCase(repository),
      );
      final params = _params(
        passengers: 2,
        departureFrom: const TimeOfDay(hour: 8, minute: 0),
      );

      await cubit.searchLeg1(
        activeParams: params,
        fromStationId: 10,
        toStationId: 20,
        fromDisplayName: 'Origin',
        toDisplayName: 'Destination',
        date: DateTime(2026, 6, 20),
      );

      expect(cubit.state.leg1Results, isEmpty);
      expect(cubit.state.hasMoreLeg1Pages, isTrue);

      await cubit.loadMoreLeg1();

      expect(repository.requestedPages, [1, 2]);
      expect(repository.requests.last.fromStationId, 10);
      expect(repository.requests.last.toStationId, 20);
      expect(cubit.state.leg1Results!.map((t) => t.tripOccurrenceId), [2]);
    });
  });
}

SearchParams _params({
  int passengers = 1,
  TimeOfDay? departureFrom,
}) {
  return SearchParams(
    travelDate: '2026-06-20',
    passengers: passengers,
    fromDisplayName: 'Origin',
    toDisplayName: 'Destination',
    fromGovernorate: 'Origin',
    toGovernorate: 'Destination',
    departureFrom: departureFrom,
  );
}

TripResultEntity _trip({required int id, required int departureHour}) {
  final departure = DateTime(2026, 6, 20, departureHour);
  return TripResultEntity(
    tripOccurrenceId: id,
    tripId: id,
    agencyName: 'Agency',
    departureTime: departure,
    arrivalTime: departure.add(const Duration(hours: 2)),
    totalDurationMinutes: 120,
    originStationId: 10,
    originStationName: 'Origin station',
    originGovernorate: 'Origin',
    destinationStationId: 20,
    destinationStationName: 'Destination station',
    destinationGovernorate: 'Destination',
    availableClasses: const [],
  );
}

class _FakeSearchRepository implements SearchRepository {
  final Map<int, List<TripResultEntity>> pages;
  final List<SearchParams> requests = [];

  _FakeSearchRepository(this.pages);

  List<int> get requestedPages => requests.map((p) => p.pageNumber).toList();

  @override
  Future<Either<Failure, PagedResultEntity<TripResultEntity>>> searchTrips({
    required SearchParams params,
  }) async {
    requests.add(params);
    return Right(
      PagedResultEntity<TripResultEntity>(
        items: pages[params.pageNumber] ?? const [],
        totalCount: pages.values.fold<int>(
          0,
          (count, items) => count + items.length,
        ),
        totalPages: pages.length,
        currentPage: params.pageNumber,
        pageSize: params.pageSize,
      ),
    );
  }

  @override
  Future<Either<Failure, PagedResultEntity<IndirectTripEntity>>>
      searchIndirectTrips({
    required SearchParams params,
  }) async {
    return Right(
      PagedResultEntity<IndirectTripEntity>(
        items: const [],
        totalCount: 0,
        totalPages: 0,
        currentPage: params.pageNumber,
        pageSize: params.pageSize,
      ),
    );
  }
}

class _FakeRecentSearchRepository implements RecentSearchRepository {
  @override
  Future<Either<Failure, void>> saveSearch(RecentSearchEntity search) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<RecentSearchEntity>>> getRecentSearches() async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, void>> deleteSearch(String id) async {
    return const Right(null);
  }
}
