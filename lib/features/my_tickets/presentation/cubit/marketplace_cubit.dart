import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/utils/token_manager.dart';
import 'package:transportation_app/features/my_tickets/domain/repositories/my_tickets_repository.dart';
import 'marketplace_states.dart';

class MarketplaceFilter {
  final String? originGovernorate;
  final String? destinationGovernorate;
  final DateTime? travelDate;

  const MarketplaceFilter({
    this.originGovernorate,
    this.destinationGovernorate,
    this.travelDate,
  });

  bool get isActive =>
      (originGovernorate != null && originGovernorate!.isNotEmpty) ||
      (destinationGovernorate != null && destinationGovernorate!.isNotEmpty) ||
      travelDate != null;

  MarketplaceFilter copyWith({
    String? originGovernorate,
    String? destinationGovernorate,
    DateTime? travelDate,
    bool clearOrigin = false,
    bool clearDestination = false,
    bool clearDate = false,
  }) {
    return MarketplaceFilter(
      originGovernorate: clearOrigin
          ? null
          : (originGovernorate ?? this.originGovernorate),
      destinationGovernorate: clearDestination
          ? null
          : (destinationGovernorate ?? this.destinationGovernorate),
      travelDate: clearDate ? null : (travelDate ?? this.travelDate),
    );
  }

  static const empty = MarketplaceFilter();
}

class MarketplaceCubit extends Cubit<MarketplaceState> {
  final MyTicketsRepository repository;
  MarketplaceFilter _currentFilter = MarketplaceFilter.empty;

  MarketplaceFilter get currentFilter => _currentFilter;

  MarketplaceCubit({required this.repository}) : super(MarketplaceInitial());

  Future<void> fetchActiveListings({
    MarketplaceFilter? filter,
    int pageNumber = 1,
  }) async {
    final f = filter ?? _currentFilter;
    _currentFilter = f;
    emit(MarketplaceLoadingState());
    final result = await repository.getActiveListings(
      pageNumber: pageNumber,
      originGovernorate: f.originGovernorate,
      destinationGovernorate: f.destinationGovernorate,
      travelDate: f.travelDate != null
          ? '${f.travelDate!.year}-${f.travelDate!.month.toString().padLeft(2, '0')}-${f.travelDate!.day.toString().padLeft(2, '0')}'
          : null,
    );
    if (isClosed) return;
    result.fold((failure) => emit(MarketplaceErrorState(failure.message)), (
      data,
    ) async {
      final items = data['items'] as List<dynamic>? ?? [];

      // Filter out own tickets by seller id when available, otherwise fall back to seller full name.
      final tokenManager = sl<TokenManager>();
      final user = await tokenManager.getUser();
      if (isClosed) return;
      List<dynamic> filteredItems = items;
      if (user != null) {
        filteredItems = items.where((item) {
          final sellerId = item['sellerId'] is int
              ? item['sellerId'] as int
              : int.tryParse('${item['sellerId']}');
          if (sellerId != null && sellerId == user.userId) return false;
          return true;
        }).toList();
      }

      emit(MarketplaceLoadedState(filteredItems, activeFilter: f));
    });
  }

  Future<void> buyTicket(
    int listingId,
    List<Map<String, dynamic>> passengers,
  ) async {
    emit(MarketplaceBuyingState());
    final result = await repository.buyTicket(
      listingId: listingId,
      passengers: passengers,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(MarketplaceBuyErrorState(failure.message)),
      (_) => emit(MarketplaceBoughtState()),
    );
  }

  Future<void> listTicket({
    required int bookingId,
    required double askingPrice,
  }) async {
    emit(MarketplaceListingState());
    final result = await repository.listTicket(
      bookingId: bookingId,
      askingPrice: askingPrice,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(MarketplaceListErrorState(failure.message)),
      (_) => emit(MarketplaceListedState()),
    );
  }

  Future<void> cancelListing({required int listingId}) async {
    emit(MarketplaceListingState());
    final result = await repository.cancelListing(listingId: listingId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(MarketplaceListErrorState(failure.message)),
      (_) => emit(
        MarketplaceListedState(),
      ), // Reusing listed state to trigger refresh
    );
  }
}
