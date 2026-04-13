import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/home/domain/entities/station_group_entity.dart';

abstract class StationsRepository {
  ResultFuture<List<StationGroupEntity>> getStations();
}