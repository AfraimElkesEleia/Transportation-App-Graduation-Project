import 'package:equatable/equatable.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/multidestination/presentation/screens/multidestination_summary_screen.dart';
import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';

enum MultiDestinationBookingStep { searchLegs, selectSeats, summary }

class MultiDestinationBookingState extends Equatable {
  final List<MultiDestinationLegSummary> legSummaries;
  final MultiDestinationBookingStep currentStep;

  // Search Phase
  final int currentSearchLegIndex;
  final bool isSearching;
  final String? searchError;
  final List<TripResultEntity>? searchResults;
  final int currentPage;
  final int totalPages;
  final bool isFetchingMore;
  final SearchParams? currentActiveParams;

  // Selected Data
  final Map<int, TripResultEntity> selectedTrips;
  final Map<int, CoachClassEntity> selectedClasses;

  // Seats Phase
  final int currentSeatLegIndex;
  final Map<int, List<String>> selectedSeats;

  // Checkout
  final bool isAddingToCart;
  final bool isBookingNow;
  final bool cartSuccess;
  final bool checkoutSuccess;
  final String? cartError;

  const MultiDestinationBookingState({
    required this.legSummaries,
    this.currentStep = MultiDestinationBookingStep.searchLegs,
    this.currentSearchLegIndex = 0,
    this.isSearching = false,
    this.searchError,
    this.searchResults,
    this.currentPage = 1,
    this.totalPages = 1,
    this.isFetchingMore = false,
    this.currentActiveParams,
    this.selectedTrips = const {},
    this.selectedClasses = const {},
    this.currentSeatLegIndex = 0,
    this.selectedSeats = const {},
    this.isAddingToCart = false,
    this.isBookingNow = false,
    this.cartSuccess = false,
    this.checkoutSuccess = false,
    this.cartError,
  });

  int get requiredSeatCount {
    if (selectedSeats.isEmpty) return 0;
    return selectedSeats[0]?.length ?? 0;
  }

  MultiDestinationBookingState copyWith({
    MultiDestinationBookingStep? currentStep,
    int? currentSearchLegIndex,
    bool? isSearching,
    String? searchError,
    bool clearSearchError = false,
    List<TripResultEntity>? searchResults,
    int? currentPage,
    int? totalPages,
    bool? isFetchingMore,
    SearchParams? currentActiveParams,
    Map<int, TripResultEntity>? selectedTrips,
    Map<int, CoachClassEntity>? selectedClasses,
    int? currentSeatLegIndex,
    Map<int, List<String>>? selectedSeats,
    bool? isAddingToCart,
    bool? isBookingNow,
    bool? cartSuccess,
    bool? checkoutSuccess,
    String? cartError,
    bool clearCartError = false,
  }) {
    return MultiDestinationBookingState(
      legSummaries: legSummaries,
      currentStep: currentStep ?? this.currentStep,
      currentSearchLegIndex:
          currentSearchLegIndex ?? this.currentSearchLegIndex,
      isSearching: isSearching ?? this.isSearching,
      searchError: clearSearchError ? null : (searchError ?? this.searchError),
      searchResults: searchResults ?? this.searchResults,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      currentActiveParams: currentActiveParams ?? this.currentActiveParams,
      selectedTrips: selectedTrips ?? this.selectedTrips,
      selectedClasses: selectedClasses ?? this.selectedClasses,
      currentSeatLegIndex: currentSeatLegIndex ?? this.currentSeatLegIndex,
      selectedSeats: selectedSeats ?? this.selectedSeats,
      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
      isBookingNow: isBookingNow ?? this.isBookingNow,
      cartSuccess: cartSuccess ?? this.cartSuccess,
      checkoutSuccess: checkoutSuccess ?? this.checkoutSuccess,
      cartError: clearCartError ? null : (cartError ?? this.cartError),
    );
  }

  @override
  List<Object?> get props => [
    legSummaries,
    currentStep,
    currentSearchLegIndex,
    isSearching,
    searchError,
    searchResults,
    currentPage,
    totalPages,
    isFetchingMore,
    currentActiveParams,
    selectedTrips,
    selectedClasses,
    currentSeatLegIndex,
    selectedSeats,
    isAddingToCart,
    isBookingNow,
    cartSuccess,
    checkoutSuccess,
    cartError,
  ];
}
