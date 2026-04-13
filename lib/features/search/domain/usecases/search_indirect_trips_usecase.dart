import 'package:dartz/dartz.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/core/usecases/usecase.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/domain/entities/indirect_trips_enitity.dart';
import 'package:transportation_app/features/search/domain/repository/search_repository.dart';

class SearchIndirectTripsUseCase
    extends Usecase<List<IndirectTripEntity>, SearchParams> {
  final SearchRepository repository;
  SearchIndirectTripsUseCase(this.repository);

  @override
  Future<Either<Failure, List<IndirectTripEntity>>> call(SearchParams params) {
    return repository.searchIndirectTrips(params);
  }
}