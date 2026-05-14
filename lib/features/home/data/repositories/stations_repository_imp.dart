import 'package:dartz/dartz.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/home/data/datasource/stations_remote_datasource.dart';
import 'package:transportation_app/features/home/domain/entities/station_group_entity.dart';
import 'package:transportation_app/features/home/domain/repositories/station_repository.dart';

class StationsRepositoryImpl implements StationsRepository {
  final StationsRemoteDatasource remoteDataSource;
  StationsRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<List<StationGroupEntity>> getStations() async {
    try {
      final groups = await remoteDataSource.getStations();
      return Right(groups.cast<StationGroupEntity>());
    } on NetworkException {
      return Left(const NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}