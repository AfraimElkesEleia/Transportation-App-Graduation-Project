import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/marketplace_cubit.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/marketplace_states.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/marketplace_filter_sheet.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_states.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/marketplace_stat_box.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/marketplace_ticket_card.dart';

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
    final profileState = context.watch<ProfileCubit>().state;
    final currentUserName = profileState is ProfileLoaded
        ? profileState.profile.fullName
        : '';

    return Scaffold(
      backgroundColor: ColorsManager.darkBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorsManager.accentCyan),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ticket Marketplace',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Find great deals from other travelers',
              style: TextStyle(color: Colors.white70, fontSize: 12),
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
        listener: (context, state) {
          if (state is MarketplaceBoughtState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ticket purchased successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            context.read<MarketplaceCubit>().fetchActiveListings();
          } else if (state is MarketplaceBuyErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is MarketplaceListedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Listing cancelled successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            context.read<MarketplaceCubit>().fetchActiveListings();
          } else if (state is MarketplaceListErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        buildWhen: (previous, current) =>
            current is MarketplaceLoadingState ||
            current is MarketplaceLoadedState ||
            current is MarketplaceErrorState ||
            current is MarketplaceInitial,
        builder: (context, state) {
          final cubit = context.read<MarketplaceCubit>();
          final filter = cubit.currentFilter;
          final isFilterActive = filter.isActive;

          return CustomScrollView(
            slivers: [
              // ── Sticky filter bar ───────────────────────────────────────
              SliverPersistentHeader(
                pinned: true,
                delegate: _SearchBarDelegate(
                  child: Container(
                    color: ColorsManager.darkBlue,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Filter button — full width
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () => _openFilterSheet(context, filter),
                            icon: Icon(
                              Icons.tune,
                              size: 18,
                              color: isFilterActive
                                  ? ColorsManager.accentCyan
                                  : Colors.white,
                            ),
                            label: Text(
                              isFilterActive ? 'Filters (active)' : 'Filters',
                              style: TextStyle(
                                color: isFilterActive
                                    ? ColorsManager.accentCyan
                                    : Colors.white,
                                fontWeight: isFilterActive
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 15,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: isFilterActive
                                    ? ColorsManager.accentCyan
                                    : Colors.white24,
                                width: isFilterActive ? 1.5 : 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: isFilterActive
                                  ? ColorsManager.accentCyan.withOpacity(0.08)
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                        // Active dot badge
                        if (isFilterActive)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: ColorsManager.accentCyan,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  height: 64,
                ),
              ),

              // ── Active filter chips ─────────────────────────────────────
              if (isFilterActive)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (filter.originGovernorate != null &&
                            filter.originGovernorate!.isNotEmpty)
                          _ActiveFilterChip(
                            label: 'From: ${filter.originGovernorate}',
                            onRemove: () => cubit.fetchActiveListings(
                              filter: filter.copyWith(clearOrigin: true),
                            ),
                          ),
                        if (filter.destinationGovernorate != null &&
                            filter.destinationGovernorate!.isNotEmpty)
                          _ActiveFilterChip(
                            label: 'To: ${filter.destinationGovernorate}',
                            onRemove: () => cubit.fetchActiveListings(
                              filter: filter.copyWith(clearDestination: true),
                            ),
                          ),
                        if (filter.travelDate != null)
                          _ActiveFilterChip(
                            label:
                                'Date: ${filter.travelDate!.day}/${filter.travelDate!.month}/${filter.travelDate!.year}',
                            onRemove: () => cubit.fetchActiveListings(
                              filter: filter.copyWith(clearDate: true),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

              // ── Stats row ───────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Builder(
                    builder: (ctx) {
                      final count = (state is MarketplaceLoadedState)
                          ? state.listings.where((l) {
                              return (l['sellerName'] as String?) !=
                                  currentUserName;
                            }).length
                          : 0;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MarketplaceStatBox(
                            icon: Icons.trending_up,
                            value: '$count',
                            label: 'Available',
                            color: Colors.greenAccent,
                          ),
                          MarketplaceStatBox(
                            icon: Icons.bolt,
                            value:
                                (state is MarketplaceLoadedState && count > 0)
                                ? _avgDiscount(state.listings)
                                : '—',
                            label: 'Avg. Discount',
                            color: Colors.amber,
                          ),
                          MarketplaceStatBox(
                            icon: Icons.groups,
                            value: '$count',
                            label: 'Total Listings',
                            color: Colors.blueAccent,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // ── Listings ────────────────────────────────────────────────
              if (state is MarketplaceLoadingState)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ColorsManager.accentCyan,
                    ),
                  ),
                )
              else if (state is MarketplaceErrorState)
                SliverFillRemaining(
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
                          state.message,
                          style: const TextStyle(color: Colors.redAccent),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => cubit.fetchActiveListings(),
                          child: const Text(
                            'Retry',
                            style: TextStyle(color: ColorsManager.accentCyan),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (state is MarketplaceLoadedState) ...[
                if (state.listings.isEmpty)
                  SliverFillRemaining(
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
                          const Text(
                            'No listings found.',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (isFilterActive) ...[
                            const SizedBox(height: 8),
                            const Text(
                              'Try removing some filters.',
                              style: TextStyle(
                                color: Colors.white30,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton.icon(
                              onPressed: () => cubit.fetchActiveListings(
                                filter: MarketplaceFilter.empty,
                              ),
                              icon: const Icon(
                                Icons.filter_alt_off,
                                color: ColorsManager.accentCyan,
                              ),
                              label: const Text(
                                'Clear Filters',
                                style: TextStyle(
                                  color: ColorsManager.accentCyan,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((ctx, index) {
                        final item =
                            state.listings[index] as Map<String, dynamic>;
                        final trip =
                            item['tripDetails'] as Map<String, dynamic>? ?? {};

                        // ── Correct API field names ──────────────────────
                        final originGov = trip['originGov'] as String? ?? '';
                        final destinationGov =
                            trip['destinationGov'] as String? ?? '';
                        // Arabic station/city names — used as subtitle
                        final originCity = trip['origin'] as String? ?? '';
                        final destinationCity =
                            trip['destination'] as String? ?? '';

                        // Header: English gov names; fall back to Arabic
                        final fromLabel = originGov.isNotEmpty
                            ? originGov
                            : originCity;
                        final toLabel = destinationGov.isNotEmpty
                            ? destinationGov
                            : destinationCity;

                        // Subtitle: Arabic station name (dimmed, smaller)
                        final fromLocation = originCity.isNotEmpty
                            ? originCity
                            : null;
                        final toLocation = destinationCity.isNotEmpty
                            ? destinationCity
                            : null;

                        final timeStr = trip['time'] as String? ?? '';
                        final dt = DateTime.tryParse(timeStr) ?? DateTime.now();
                        final oldPrice = (item['originalPrice'] as num? ?? 0)
                            .toDouble();
                        final newPrice = (item['askingPrice'] as num? ?? 0)
                            .toDouble();
                        final discountVal = oldPrice > 0
                            ? ((oldPrice - newPrice) / oldPrice * 100).round()
                            : 0;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: MarketplaceTicketCard(
                            fromTo: '$fromLabel → $toLabel',
                            originGov: originGov.isNotEmpty ? originGov : null,
                            destinationGov: destinationGov.isNotEmpty
                                ? destinationGov
                                : null,
                            fromLocation: fromLocation,
                            toLocation: toLocation,
                            date: '${dt.day}/${dt.month}/${dt.year}',
                            time:
                                '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}',
                            className: _cleanClassName(
                              trip['class'] as String? ?? 'Standard',
                            ),
                            sellerName:
                                item['sellerName'] as String? ?? 'Seller',
                            agencyName: item['agencyName'] as String? ?? item['agency'] as String?,
                            oldPrice: '$oldPrice EGP',
                            newPrice: '$newPrice EGP',
                            discount: '-$discountVal%',
                            onBuy: () => _showBuyDialog(context, item, cubit),
                          ),
                        );
                      }, childCount: state.listings.length),
                    ),
                  ),
              ] else
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: SizedBox(),
                ),
            ],
          );
        },
      ),
    );
  }

  String _avgDiscount(List<dynamic> listings) {
    if (listings.isEmpty) return '—';
    double sum = 0;
    for (final l in listings) {
      final item = l as Map<String, dynamic>;
      final old = (item['originalPrice'] as num? ?? 0).toDouble();
      final ask = (item['askingPrice'] as num? ?? 0).toDouble();
      if (old > 0) sum += (old - ask) / old * 100;
    }
    return '${(sum / listings.length).round()}%';
  }

  /// Removes duplicate agency prefix from class names.
  /// e.g. "GoBus - GoBus - GoMini" → "GoBus - GoMini"
  String _cleanClassName(String raw) {
    final parts = raw.split(' - ');
    final seen = <String>{};
    final deduped = parts.where((p) => seen.add(p.trim())).toList();
    return deduped.join(' - ');
  }

  void _showBuyDialog(
    BuildContext context,
    Map<String, dynamic> item,
    MarketplaceCubit cubit,
  ) {
    final trip = item['tripDetails'] as Map<String, dynamic>? ?? {};
    // Correct API field names
    final originGov = trip['originGov'] as String? ?? '';
    final destinationGov = trip['destinationGov'] as String? ?? '';
    final originCity = trip['origin'] as String? ?? '';
    final destinationCity = trip['destination'] as String? ?? '';
    // Build display strings: "Sohag, سوهاج الشهيد"
    final originDisplay = [
      originGov,
      originCity,
    ].where((s) => s.isNotEmpty).join(', ');
    final destinationDisplay = [
      destinationGov,
      destinationCity,
    ].where((s) => s.isNotEmpty).join(', ');
    final timeStr = trip['time'] as String? ?? '';
    final dt = DateTime.tryParse(timeStr) ?? DateTime.now();
    final className = _cleanClassName(trip['class'] as String? ?? 'Standard');
    final newPrice = (item['askingPrice'] as num? ?? 0).toDouble();
    final id = item['listingId'] as int;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ColorsManager.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(
              Icons.shopping_cart,
              color: ColorsManager.accentCyan,
              size: 22,
            ),
            SizedBox(width: 8),
            Text(
              'Buy Ticket',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Agency: ${item['agencyName'] ?? 'Unknown'}',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              if (originDisplay.isNotEmpty)
                Text(
                  'Origin: $originDisplay',
                  style: const TextStyle(color: Colors.white70),
                ),
              if (destinationDisplay.isNotEmpty)
                Text(
                  'Destination: $destinationDisplay',
                  style: const TextStyle(color: Colors.white70),
                ),
              const SizedBox(height: 8),
              Text(
                'Date: ${dt.day}/${dt.month}/${dt.year}',
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                'Time: ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Text(
                'Class: $className',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Text(
                'Price: $newPrice EGP',
                style: const TextStyle(
                  color: ColorsManager.successGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Are you sure you want to buy this ticket?',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white38),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              cubit.buyTicket(id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManager.successGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Buy Now',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sticky search bar delegate ─────────────────────────────────────────────
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  const _SearchBarDelegate({required this.child, required this.height});

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;
  @override
  bool shouldRebuild(_SearchBarDelegate old) => true;
}

// ── Active filter chip ─────────────────────────────────────────────────────
class _ActiveFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _ActiveFilterChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: ColorsManager.accentCyan.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorsManager.accentCyan.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: ColorsManager.accentCyan,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              color: ColorsManager.accentCyan,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }
}
