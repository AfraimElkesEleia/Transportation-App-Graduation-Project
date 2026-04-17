import 'package:equatable/equatable.dart';
import 'package:transportation_app/features/home/domain/entities/station_entity.dart';
import 'package:transportation_app/features/home/domain/entities/station_group_entity.dart';

abstract class StationsState extends Equatable {
  const StationsState();
  @override
  List<Object?> get props => [];
}

class StationsInitial extends StationsState {}
class StationsLoading extends StationsState {}

class StationsLoaded extends StationsState {
  final List<StationGroupEntity> groups;

  const StationsLoaded(this.groups);

  List<StationEntity> get allStations =>
      groups.expand((g) => g.stations).toList();

  List<String> get governorates => groups.map((g) => g.governorate).toList();

  @override
  List<Object?> get props => [groups];
}

class StationsError extends StationsState {
  final String message;
  const StationsError(this.message);
  @override
  List<Object?> get props => [message];
}