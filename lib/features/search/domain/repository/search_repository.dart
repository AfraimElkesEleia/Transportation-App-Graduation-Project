import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/domain/entities/indirect_trips_enitity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';

abstract class SearchRepository {
  ResultFuture<List<TripResultEntity>> searchTrips(SearchParams params);
  ResultFuture<List<IndirectTripEntity>> searchIndirectTrips(SearchParams params);
}
