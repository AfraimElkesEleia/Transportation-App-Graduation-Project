// lib/features/search/data/repositories/search_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/home/domain/entities/page_result_entity.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/data/datasources/search_remote_datasource.dart';
import 'package:transportation_app/features/search/data/model/page_result_model.dart';
import 'package:transportation_app/features/search/domain/entities/indirect_trips_enitity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';
import 'package:transportation_app/features/search/domain/repository/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDatasource remoteDataSource;
  
  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<PagedResultEntity<TripResultEntity>> searchTrips({
    required SearchParams params,
  }) async {
    try {
      final result = await remoteDataSource.searchTrips(
        params: params,
      );
      
      final entities = result.items.cast<TripResultEntity>();
      
      return Right(PagedResultEntity<TripResultEntity>(
        items: entities,
        totalCount: result.totalCount,
        totalPages: result.totalPages,
        currentPage: result.currentPage,
        pageSize: result.pageSize,
      ));
    } on NetworkException {
      return Left(const NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  ResultFuture<PagedResultEntity<IndirectTripEntity>> searchIndirectTrips({
    required SearchParams params,
  }) async {
    try {
      final result = await remoteDataSource.searchIndirectTrips(
        params: params,
      );
      
      final entities = result.items.cast<IndirectTripEntity>();
      
      return Right(PagedResultEntity<IndirectTripEntity>(
        items: entities,
        totalCount: result.totalCount,
        totalPages: result.totalPages,
        currentPage: result.currentPage,
        pageSize: result.pageSize,
      ));
      
    } on NetworkException {
      return Left(const NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message, 
        errors: e.errors,
      ));
    }
  }
}