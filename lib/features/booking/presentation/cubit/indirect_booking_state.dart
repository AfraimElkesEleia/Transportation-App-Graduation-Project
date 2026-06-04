import 'package:equatable/equatable.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';

enum IndirectBookingStep {
  searchLeg1,
  searchLeg2,
  seatLeg1,
  seatLeg2,
  summary
}

class IndirectBookingState extends Equatable {
  final IndirectBookingStep currentStep;

  // Search results for legs
  final bool isLoadingLeg1;
  final List<TripResultEntity>? leg1Results;
  final String? leg1Error;
  final int leg1CurrentPage;
  final int leg1TotalPages;
  final bool isFetchingMoreLeg1;

  final bool isLoadingLeg2;
  final List<TripResultEntity>? leg2Results;
  final String? leg2Error;
  final int leg2CurrentPage;
  final int leg2TotalPages;
  final bool isFetchingMoreLeg2;

  final SearchParams? activeParams;

  // Selections
  final TripResultEntity? selectedTripLeg1;
  final CoachClassEntity? selectedClassLeg1;
  final List<String> selectedSeatsLeg1;

  final TripResultEntity? selectedTripLeg2;
  final CoachClassEntity? selectedClassLeg2;
  final List<String> selectedSeatsLeg2;

  final int requiredSeatCount; // Enforced from Leg 1

  const IndirectBookingState({
    this.currentStep = IndirectBookingStep.searchLeg1,
    this.isLoadingLeg1 = false,
    this.leg1Results,
    this.leg1Error,
    this.leg1CurrentPage = 1,
    this.leg1TotalPages = 1,
    this.isFetchingMoreLeg1 = false,
    this.isLoadingLeg2 = false,
    this.leg2Results,
    this.leg2Error,
    this.leg2CurrentPage = 1,
    this.leg2TotalPages = 1,
    this.isFetchingMoreLeg2 = false,
    this.activeParams,
    this.selectedTripLeg1,
    this.selectedClassLeg1,
    this.selectedSeatsLeg1 = const [],
    this.selectedTripLeg2,
    this.selectedClassLeg2,
    this.selectedSeatsLeg2 = const [],
    this.requiredSeatCount = 0,
  });

  bool get hasMoreLeg1Pages => leg1CurrentPage < leg1TotalPages;
  bool get hasMoreLeg2Pages => leg2CurrentPage < leg2TotalPages;

  IndirectBookingState copyWith({
    IndirectBookingStep? currentStep,
    bool? isLoadingLeg1,
    List<TripResultEntity>? leg1Results,
    String? leg1Error,
    int? leg1CurrentPage,
    int? leg1TotalPages,
    bool? isFetchingMoreLeg1,
    bool? isLoadingLeg2,
    List<TripResultEntity>? leg2Results,
    String? leg2Error,
    int? leg2CurrentPage,
    int? leg2TotalPages,
    bool? isFetchingMoreLeg2,
    SearchParams? activeParams,
    TripResultEntity? selectedTripLeg1,
    CoachClassEntity? selectedClassLeg1,
    List<String>? selectedSeatsLeg1,
    TripResultEntity? selectedTripLeg2,
    CoachClassEntity? selectedClassLeg2,
    List<String>? selectedSeatsLeg2,
    int? requiredSeatCount,
    bool clearLeg1Error = false,
    bool clearLeg2Error = false,
    bool clearLeg2Selection = false,
  }) {
    return IndirectBookingState(
      currentStep: currentStep ?? this.currentStep,
      isLoadingLeg1: isLoadingLeg1 ?? this.isLoadingLeg1,
      leg1Results: leg1Results ?? this.leg1Results,
      leg1Error: clearLeg1Error ? null : (leg1Error ?? this.leg1Error),
      leg1CurrentPage: leg1CurrentPage ?? this.leg1CurrentPage,
      leg1TotalPages: leg1TotalPages ?? this.leg1TotalPages,
      isFetchingMoreLeg1: isFetchingMoreLeg1 ?? this.isFetchingMoreLeg1,
      isLoadingLeg2: isLoadingLeg2 ?? this.isLoadingLeg2,
      leg2Results: leg2Results ?? this.leg2Results,
      leg2Error: clearLeg2Error ? null : (leg2Error ?? this.leg2Error),
      leg2CurrentPage: leg2CurrentPage ?? this.leg2CurrentPage,
      leg2TotalPages: leg2TotalPages ?? this.leg2TotalPages,
      isFetchingMoreLeg2: isFetchingMoreLeg2 ?? this.isFetchingMoreLeg2,
      activeParams: activeParams ?? this.activeParams,
      selectedTripLeg1: selectedTripLeg1 ?? this.selectedTripLeg1,
      selectedClassLeg1: selectedClassLeg1 ?? this.selectedClassLeg1,
      selectedSeatsLeg1: selectedSeatsLeg1 ?? this.selectedSeatsLeg1,
      selectedTripLeg2: clearLeg2Selection
          ? null
          : (selectedTripLeg2 ?? this.selectedTripLeg2),
      selectedClassLeg2: clearLeg2Selection
          ? null
          : (selectedClassLeg2 ?? this.selectedClassLeg2),
      selectedSeatsLeg2: selectedSeatsLeg2 ?? this.selectedSeatsLeg2,
      requiredSeatCount: requiredSeatCount ?? this.requiredSeatCount,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        isLoadingLeg1,
        leg1Results,
        leg1Error,
        leg1CurrentPage,
        leg1TotalPages,
        isFetchingMoreLeg1,
        isLoadingLeg2,
        leg2Results,
        leg2Error,
        leg2CurrentPage,
        leg2TotalPages,
        isFetchingMoreLeg2,
        activeParams,
        selectedTripLeg1,
        selectedClassLeg1,
        selectedSeatsLeg1,
        selectedTripLeg2,
        selectedClassLeg2,
        selectedSeatsLeg2,
        requiredSeatCount,
      ];
}
