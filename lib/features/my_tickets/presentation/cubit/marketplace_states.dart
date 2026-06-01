import 'marketplace_cubit.dart';

abstract class MarketplaceState {}

class MarketplaceInitial extends MarketplaceState {}

// --- Get Active Listings ---
class MarketplaceLoadingState extends MarketplaceState {}

class MarketplaceLoadedState extends MarketplaceState {
  final List<dynamic> listings;
  final MarketplaceFilter activeFilter;
  MarketplaceLoadedState(this.listings, {required this.activeFilter});
}

class MarketplaceErrorState extends MarketplaceState {
  final String message;
  MarketplaceErrorState(this.message);
}

// --- Buy Ticket ---
class MarketplaceBuyingState extends MarketplaceState {}

class MarketplaceBoughtState extends MarketplaceState {}

class MarketplaceBuyErrorState extends MarketplaceState {
  final String message;
  MarketplaceBuyErrorState(this.message);
}

// --- List Ticket ---
class MarketplaceListingState extends MarketplaceState {}

class MarketplaceListedState extends MarketplaceState {}

class MarketplaceListErrorState extends MarketplaceState {
  final String message;
  MarketplaceListErrorState(this.message);
}
