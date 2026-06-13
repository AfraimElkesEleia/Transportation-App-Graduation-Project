import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/marketplace_cubit.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/marketplace_states.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/marketplace_buy_dialog.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/marketplace_listing_utils.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/marketplace_ticket_card.dart';

class MarketplaceListingsSliver extends StatelessWidget {
  final MarketplaceState state;
  final MarketplaceCubit cubit;
  final bool isFilterActive;

  const MarketplaceListingsSliver({
    super.key,
    required this.state,
    required this.cubit,
    required this.isFilterActive,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (state is MarketplaceLoadingState) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: CircularProgressIndicator(color: ColorsManager.accentCyan),
        ),
      );
    }

    if (state is MarketplaceErrorState) {
      final errorState = state as MarketplaceErrorState;
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                color: Colors.white24,
                size: 54,
              ),
              const SizedBox(height: 12),
              Text(
                errorState.message,
                style: const TextStyle(color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => cubit.fetchActiveListings(),
                child: Text(
                  l10n.retry,
                  style: const TextStyle(color: ColorsManager.accentCyan),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state is! MarketplaceLoadedState) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: SizedBox(),
      );
    }

    final loadedState = state as MarketplaceLoadedState;
    if (loadedState.listings.isEmpty) {
      return _MarketplaceEmptyListingsSliver(
        isFilterActive: isFilterActive,
        onClearFilters: () =>
            cubit.fetchActiveListings(filter: MarketplaceFilter.empty),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((ctx, index) {
          final item = loadedState.listings[index] as Map<String, dynamic>;
          final display = MarketplaceListingDisplay.fromJson(
            ctx,
            item,
            sellerFallback: l10n.sellerLabel,
            standardClassFallback: l10n.standardClass,
          );

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: MarketplaceTicketCard(
              fromTo: display.fromTo,
              originGov: display.originGov.isNotEmpty
                  ? display.originGov
                  : null,
              destinationGov: display.destinationGov.isNotEmpty
                  ? display.destinationGov
                  : null,
              fromLocation: display.fromLocation,
              toLocation: display.toLocation,
              date:
                  '${display.departureTime.day}/${display.departureTime.month}/${display.departureTime.year}',
              time:
                  '${display.departureTime.hour.toString().padLeft(2, '0')}:${display.departureTime.minute.toString().padLeft(2, '0')}',
              className: display.className,
              sellerName: display.sellerName,
              agencyName: display.agencyName,
              oldPrice: '${display.oldPrice.toStringAsFixed(2)} ${l10n.egp}',
              newPrice: '${display.newPrice.toStringAsFixed(2)} ${l10n.egp}',
              discount: display.discountLabel,
              forSaleLabel: l10n.availableForSale,
              classLabel: l10n.classLabel,
              sellerLabel: l10n.sellerLabel,
              buyNowLabel: l10n.buyNow,
              onBuy: () => showMarketplaceBuyDialog(
                context,
                item: item,
                cubit: cubit,
              ),
            ),
          );
        }, childCount: loadedState.listings.length),
      ),
    );
  }
}

class _MarketplaceEmptyListingsSliver extends StatelessWidget {
  final bool isFilterActive;
  final VoidCallback onClearFilters;

  const _MarketplaceEmptyListingsSliver({
    required this.isFilterActive,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off_rounded,
              color: Colors.white24,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noListingsFound,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isFilterActive) ...[
              const SizedBox(height: 8),
              Text(
                l10n.tryRemovingFilters,
                style: const TextStyle(color: Colors.white30, fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: onClearFilters,
                icon: const Icon(
                  Icons.filter_alt_off,
                  color: ColorsManager.accentCyan,
                ),
                label: Text(
                  l10n.clearFilters,
                  style: const TextStyle(color: ColorsManager.accentCyan),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
