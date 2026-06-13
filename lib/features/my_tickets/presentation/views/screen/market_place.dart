import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/marketplace_cubit.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/marketplace_states.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/marketplace_filter_controls.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/marketplace_filter_sheet.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/marketplace_listings_sliver.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/marketplace_stats_sliver.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_states.dart';

/// Marketplace screen showing available tickets from other travelers.
///
/// Supports live filtering by origin/destination governorate and travel date,
/// backed by the /api/Marketplace/active endpoint.
class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  void _openFilterSheet(BuildContext ctx, MarketplaceFilter currentFilter) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MarketplaceFilterSheet(
        currentFilter: currentFilter,
        onApply: (newFilter) {
          ctx.read<MarketplaceCubit>().fetchActiveListings(filter: newFilter);
        },
        onReset: () {
          ctx.read<MarketplaceCubit>().fetchActiveListings(
            filter: MarketplaceFilter.empty,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profileState = context.watch<ProfileCubit>().state;
    final currentUserId = profileState is ProfileLoaded
        ? profileState.profile.userId
        : null;

    return Scaffold(
      backgroundColor: ColorsManager.darkBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorsManager.accentCyan),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.ticketMarketplace,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              l10n.findDealsFromTravelers,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
      body: BlocConsumer<MarketplaceCubit, MarketplaceState>(
        listenWhen: (previous, current) =>
            current is MarketplaceBoughtState ||
            current is MarketplaceBuyErrorState ||
            current is MarketplaceListedState ||
            current is MarketplaceListErrorState,
        listener: _handleMarketplaceSideEffects,
        buildWhen: (previous, current) =>
            current is MarketplaceLoadingState ||
            current is MarketplaceLoadedState ||
            current is MarketplaceErrorState ||
            current is MarketplaceInitial,
        builder: (context, state) {
          final cubit = context.read<MarketplaceCubit>();
          final filter = cubit.currentFilter;
          final isFilterActive = filter.isActive;
          final listings = state is MarketplaceLoadedState
              ? state.listings
              : <dynamic>[];

          return CustomScrollView(
            slivers: [
              MarketplaceFilterBar(
                isFilterActive: isFilterActive,
                onPressed: () => _openFilterSheet(context, filter),
              ),
              MarketplaceActiveFilterChips(
                filter: filter,
                onChanged: (newFilter) =>
                    cubit.fetchActiveListings(filter: newFilter),
              ),
              MarketplaceStatsSliver(
                listings: listings,
                currentUserId: currentUserId,
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              MarketplaceListingsSliver(
                state: state,
                cubit: cubit,
                isFilterActive: isFilterActive,
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleMarketplaceSideEffects(
    BuildContext context,
    MarketplaceState state,
  ) {
    final l10n = AppLocalizations.of(context)!;
    if (state is MarketplaceBoughtState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.ticketPurchasedSuccessfully),
          backgroundColor: Colors.green,
        ),
      );
      context.read<MarketplaceCubit>().fetchActiveListings();
    } else if (state is MarketplaceBuyErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    } else if (state is MarketplaceListedState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.listingCancelledSuccessfully),
          backgroundColor: Colors.green,
        ),
      );
      context.read<MarketplaceCubit>().fetchActiveListings();
    } else if (state is MarketplaceListErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    }
  }
}
