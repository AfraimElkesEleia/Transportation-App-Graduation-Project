import 'package:dartz/dartz.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/core/usecases/usecase.dart';
import 'package:transportation_app/features/home/domain/entities/station_group_entity.dart';
import 'package:transportation_app/features/home/domain/repositories/station_repository.dart';

class GetStationsUseCase extends Usecase<List<StationGroupEntity>, NoParams> {
  final StationsRepository repository;
  GetStationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<StationGroupEntity>>> call(NoParams params) {
    return repository.getStations();
  }
}