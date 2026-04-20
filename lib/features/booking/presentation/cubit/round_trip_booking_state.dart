import 'package:equatable/equatable.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/domain/entities/coach_class_entity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';

enum RoundTripBookingStep {
  searchOutbound,
  searchReturn,
  selectSeats,
  summary,
}

class RoundTripBookingState extends Equatable {
  final RoundTripBookingStep currentStep;
  final SearchParams? activeParams;

  // ── Outbound ──
  final bool isLoadingOutbound;
  final String? outboundError;
  final List<TripResultEntity>? outboundResults;
  final int outboundCurrentPage;
  final int outboundTotalPages;
  final bool isFetchingMoreOutbound;

  final TripResultEntity? selectedOutboundTrip;
  final CoachClassEntity? selectedOutboundClass;
  final List<String> selectedOutboundSeats;

  // ── Return ──
  final bool isLoadingReturn;
  final String? returnError;
  final List<TripResultEntity>? returnResults;
  final int returnCurrentPage;
  final int returnTotalPages;
  final bool isFetchingMoreReturn;

  final TripResultEntity? selectedReturnTrip;
  final CoachClassEntity? selectedReturnClass;
  final List<String> selectedReturnSeats;

  // ── Booking Status ──
  final bool isAddingToCart;
  final String? cartError;
  final bool cartSuccess;

  int get requiredSeatCount {
    if (selectedOutboundSeats.isNotEmpty) {
      return selectedOutboundSeats.length;
    }
    return activeParams?.passengers ?? 1;
  }

  bool get hasMoreOutboundPages => outboundCurrentPage < outboundTotalPages;
  bool get hasMoreReturnPages => returnCurrentPage < returnTotalPages;

  const RoundTripBookingState({
    this.currentStep = RoundTripBookingStep.searchOutbound,
    this.activeParams,
    
    this.isLoadingOutbound = false,
    this.outboundError,
    this.outboundResults,
    this.outboundCurrentPage = 1,
    this.outboundTotalPages = 1,
    this.isFetchingMoreOutbound = false,
    
    this.selectedOutboundTrip,
    this.selectedOutboundClass,
    this.selectedOutboundSeats = const [],
    
    this.isLoadingReturn = false,
    this.returnError,
    this.returnResults,
    this.returnCurrentPage = 1,
    this.returnTotalPages = 1,
    this.isFetchingMoreReturn = false,
    
    this.selectedReturnTrip,
    this.selectedReturnClass,
    this.selectedReturnSeats = const [],

    this.isAddingToCart = false,
    this.cartError,
    this.cartSuccess = false,
  });

  RoundTripBookingState copyWith({
    RoundTripBookingStep? currentStep,
    SearchParams? activeParams,

    bool? isLoadingOutbound,
    String? outboundError,
    bool clearOutboundError = false,
    List<TripResultEntity>? outboundResults,
    int? outboundCurrentPage,
    int? outboundTotalPages,
    bool? isFetchingMoreOutbound,
    
    TripResultEntity? selectedOutboundTrip,
    CoachClassEntity? selectedOutboundClass,
    List<String>? selectedOutboundSeats,

    bool? isLoadingReturn,
    String? returnError,
    bool clearReturnError = false,
    List<TripResultEntity>? returnResults,
    int? returnCurrentPage,
    int? returnTotalPages,
    bool? isFetchingMoreReturn,
    
    TripResultEntity? selectedReturnTrip,
    CoachClassEntity? selectedReturnClass,
    List<String>? selectedReturnSeats,

    bool? isAddingToCart,
    String? cartError,
    bool clearCartError = false,
    bool? cartSuccess,
  }) {
    return RoundTripBookingState(
      currentStep: currentStep ?? this.currentStep,
      activeParams: activeParams ?? this.activeParams,

      isLoadingOutbound: isLoadingOutbound ?? this.isLoadingOutbound,
      outboundError: clearOutboundError ? null : outboundError ?? this.outboundError,
      outboundResults: outboundResults ?? this.outboundResults,
      outboundCurrentPage: outboundCurrentPage ?? this.outboundCurrentPage,
      outboundTotalPages: outboundTotalPages ?? this.outboundTotalPages,
      isFetchingMoreOutbound: isFetchingMoreOutbound ?? this.isFetchingMoreOutbound,
      
      selectedOutboundTrip: selectedOutboundTrip ?? this.selectedOutboundTrip,
      selectedOutboundClass: selectedOutboundClass ?? this.selectedOutboundClass,
      selectedOutboundSeats: selectedOutboundSeats ?? this.selectedOutboundSeats,

      isLoadingReturn: isLoadingReturn ?? this.isLoadingReturn,
      returnError: clearReturnError ? null : returnError ?? this.returnError,
      returnResults: returnResults ?? this.returnResults,
      returnCurrentPage: returnCurrentPage ?? this.returnCurrentPage,
      returnTotalPages: returnTotalPages ?? this.returnTotalPages,
      isFetchingMoreReturn: isFetchingMoreReturn ?? this.isFetchingMoreReturn,
      
      selectedReturnTrip: selectedReturnTrip ?? this.selectedReturnTrip,
      selectedReturnClass: selectedReturnClass ?? this.selectedReturnClass,
      selectedReturnSeats: selectedReturnSeats ?? this.selectedReturnSeats,

      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
      cartError: clearCartError ? null : cartError ?? this.cartError,
      cartSuccess: cartSuccess ?? this.cartSuccess,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        activeParams,
        isLoadingOutbound,
        outboundError,
        outboundResults,
        outboundCurrentPage,
        outboundTotalPages,
        isFetchingMoreOutbound,
        selectedOutboundTrip,
        selectedOutboundClass,
        selectedOutboundSeats,
        isLoadingReturn,
        returnError,
        returnResults,
        returnCurrentPage,
        returnTotalPages,
        isFetchingMoreReturn,
        selectedReturnTrip,
        selectedReturnClass,
        selectedReturnSeats,
        isAddingToCart,
        cartError,
        cartSuccess,
      ];
}
