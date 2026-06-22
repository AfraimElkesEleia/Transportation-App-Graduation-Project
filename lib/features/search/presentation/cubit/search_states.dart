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
  final List<TripResultEntity> directItems;
  final List<TripResultEntity> unfilteredDirectItems;
  final int directCurrentPage;
  final int directTotalPages;
  final bool isFetchingMoreDirect;
  final List<IndirectTripEntity> indirectItems;
  final int indirectCurrentPage;
  final int indirectTotalPages;
  final bool isFetchingMoreIndirect;
  final bool indirectSearched;
  final bool indirectLoading;
  final String? indirectError;
  final SearchParams activeParams;
  const SearchLoaded({
    required this.directItems,
    List<TripResultEntity>? unfilteredDirectItems,
    required this.directCurrentPage,
    required this.directTotalPages,
    this.isFetchingMoreDirect = false,
    this.indirectItems = const [],
    this.indirectCurrentPage = 0,
    this.indirectTotalPages = 0,
    this.isFetchingMoreIndirect = false,
    this.indirectSearched = false,
    this.indirectLoading = false,
    this.indirectError,
    required this.activeParams,
  }) : unfilteredDirectItems = unfilteredDirectItems ?? directItems;

  bool get hasDirectTrips => directItems.isNotEmpty;
  bool get hasMoreDirectPages => directCurrentPage < directTotalPages;
  bool get hasMoreIndirectPages => indirectCurrentPage < indirectTotalPages;
  SearchLoaded copyWith({
    List<TripResultEntity>? directItems,
    List<TripResultEntity>? unfilteredDirectItems,
    int? directCurrentPage,
    int? directTotalPages,
    bool? isFetchingMoreDirect,
    List<IndirectTripEntity>? indirectItems,
    int? indirectCurrentPage,
    int? indirectTotalPages,
    bool? isFetchingMoreIndirect,
    bool? indirectSearched,
    bool? indirectLoading,
    String? indirectError,
    bool clearIndirectError = false,
    SearchParams? activeParams,
  }) {
    return SearchLoaded(
      directItems: directItems ?? this.directItems,
      unfilteredDirectItems:
          unfilteredDirectItems ?? this.unfilteredDirectItems,
      directCurrentPage: directCurrentPage ?? this.directCurrentPage,
      directTotalPages: directTotalPages ?? this.directTotalPages,
      isFetchingMoreDirect: isFetchingMoreDirect ?? this.isFetchingMoreDirect,
      indirectItems: indirectItems ?? this.indirectItems,
      indirectCurrentPage: indirectCurrentPage ?? this.indirectCurrentPage,
      indirectTotalPages: indirectTotalPages ?? this.indirectTotalPages,
      isFetchingMoreIndirect:
          isFetchingMoreIndirect ?? this.isFetchingMoreIndirect,
      indirectSearched: indirectSearched ?? this.indirectSearched,
      indirectLoading: indirectLoading ?? this.indirectLoading,
      indirectError: clearIndirectError
          ? null
          : indirectError ?? this.indirectError,
      activeParams: activeParams ?? this.activeParams,
    );
  }

  @override
  List<Object?> get props => [
    directItems,
    unfilteredDirectItems,
    directCurrentPage,
    directTotalPages,
    isFetchingMoreDirect,
    indirectItems,
    indirectCurrentPage,
    indirectTotalPages,
    isFetchingMoreIndirect,
    indirectSearched,
    indirectLoading,
    indirectError,
    activeParams,
  ];
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
  @override
  List<Object?> get props => [message];
}
