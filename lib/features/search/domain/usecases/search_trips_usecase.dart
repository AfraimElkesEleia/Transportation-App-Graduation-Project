import 'package:dartz/dartz.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/core/usecases/usecase.dart';
import 'package:transportation_app/features/home/domain/entities/page_result_entity.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';
import 'package:transportation_app/features/search/domain/repository/search_repository.dart';

class SearchTripsUseCase extends Usecase<PagedResultEntity<TripResultEntity>, SearchParams> {
  final SearchRepository repository;
  SearchTripsUseCase(this.repository);

  @override
  Future<Either<Failure, PagedResultEntity<TripResultEntity>>> call(SearchParams params) {
    return repository.searchTrips(params: params);
  }
}