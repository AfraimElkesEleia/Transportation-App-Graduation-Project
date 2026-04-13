import 'package:dartz/dartz.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/data/datasources/search_remote_datasource.dart';
import 'package:transportation_app/features/search/domain/entities/indirect_trips_enitity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';
import 'package:transportation_app/features/search/domain/repository/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDatasource remoteDataSource;
  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<List<TripResultEntity>> searchTrips(SearchParams params) async {
    try {
      final trips = await remoteDataSource.searchTrips(params);
      return Right(trips);
    } on NetworkException {
      return Left(const NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, errors: e.errors));
    }
  }

  @override
  ResultFuture<List<IndirectTripEntity>> searchIndirectTrips(
      SearchParams params) async {
    try {
      final trips = await remoteDataSource.searchIndirectTrips(params);
      return Right(trips);
    } on NetworkException {
      return Left(const NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, errors: e.errors));
    }
  }
}