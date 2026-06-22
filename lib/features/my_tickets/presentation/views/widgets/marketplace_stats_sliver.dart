import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/marketplace_listing_utils.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/marketplace_stat_box.dart';

class MarketplaceStatsSliver extends StatelessWidget {
  final List<dynamic> listings;
  final int? currentUserId;

  const MarketplaceStatsSliver({
    super.key,
    required this.listings,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final visibleListings = visibleMarketplaceListings(listings, currentUserId);
    final count = visibleListings.length;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MarketplaceStatBox(
              icon: Icons.bolt,
              value: count > 0
                  ? marketplaceAverageDiscount(visibleListings)
                  : '\u2014',
              label: l10n.avgDiscount,
              color: Colors.amber,
            ),
            MarketplaceStatBox(
              icon: Icons.groups,
              value: '$count',
              label: l10n.totalListings,
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
