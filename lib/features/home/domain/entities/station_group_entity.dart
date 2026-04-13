import 'package:equatable/equatable.dart';
import 'station_entity.dart';

class StationGroupEntity extends Equatable {
  final String              governorate;
  final List<StationEntity> stations;

  const StationGroupEntity({
    required this.governorate,
    required this.stations,
  });

  @override
  List<Object> get props => [governorate];
}