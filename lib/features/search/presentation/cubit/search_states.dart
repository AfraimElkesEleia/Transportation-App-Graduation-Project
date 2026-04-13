import 'package:equatable/equatable.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/domain/entities/indirect_trips_enitity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<TripResultEntity>   directTrips;
  final List<IndirectTripEntity> indirectTrips;
  final List<TripResultEntity>   filteredDirect;
  final List<IndirectTripEntity> filteredIndirect;
  final SearchParams             activeParams;

  const SearchLoaded({
    required this.directTrips,
    required this.indirectTrips,
    required this.filteredDirect,
    required this.filteredIndirect,
    required this.activeParams,
  });

  bool get hasDirectTrips   => filteredDirect.isNotEmpty;
  bool get hasIndirectTrips => filteredIndirect.isNotEmpty;

  @override
  List<Object?> get props => [
    directTrips, indirectTrips,
    filteredDirect, filteredIndirect,
    activeParams,
  ];
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
  @override
  List<Object?> get props => [message];
}