import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/marketplace_cubit.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/marketplace_states.dart';
import 'package:transportation_app/core/routing/routes.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final profileState = context.watch<ProfileCubit>().state;
    final currentUserId = profileState is ProfileLoaded
        ? profileState.profile.userId
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
        listener: (context, state) {
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
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
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
                              isFilterActive
                                  ? l10n.filtersActive
                                  : l10n.filters,
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
                                  ? ColorsManager.accentCyan.withValues(
                                      alpha: 0.08,
                                    )
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
                            label: l10n.filterFrom(filter.originGovernorate!),
                            onRemove: () => cubit.fetchActiveListings(
                              filter: filter.copyWith(clearOrigin: true),
                            ),
                          ),
                        if (filter.destinationGovernorate != null &&
                            filter.destinationGovernorate!.isNotEmpty)
                          _ActiveFilterChip(
                            label: l10n.filterTo(
                              filter.destinationGovernorate!,
                            ),
                            onRemove: () => cubit.fetchActiveListings(
                              filter: filter.copyWith(clearDestination: true),
                            ),
                          ),
                        if (filter.travelDate != null)
                          _ActiveFilterChip(
                            label: l10n.filterDate(
                              '${filter.travelDate!.day}/${filter.travelDate!.month}/${filter.travelDate!.year}',
                            ),
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
                      final visibleListings = (state is MarketplaceLoadedState)
                          ? state.listings.where((l) {
                              return (l['sellerId'] as int?) != currentUserId;
                            }).toList()
                          : <dynamic>[];
                      final count = visibleListings.length;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MarketplaceStatBox(
                            icon: Icons.bolt,
                            value: count > 0
                                ? _avgDiscount(visibleListings)
                                : '—',
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
                          child: Text(
                            l10n.retry,
                            style: const TextStyle(
                              color: ColorsManager.accentCyan,
                            ),
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
                              style: const TextStyle(
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
                              label: Text(
                                l10n.clearFilters,
                                style: const TextStyle(
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
                        final isArabic =
                            Localizations.localeOf(ctx).languageCode == 'ar';

                        // ── Correct API field names ──────────────────────
                        final originGov = _localizedField(
                          trip,
                          isArabic: isArabic,
                          key: 'originGov',
                          arabicKeys: const [
                            'originGovAr',
                            'originGovernorateAr',
                          ],
                        );
                        final destinationGov = _localizedField(
                          trip,
                          isArabic: isArabic,
                          key: 'destinationGov',
                          arabicKeys: const [
                            'destinationGovAr',
                            'destinationGovernorateAr',
                          ],
                        );
                        // Arabic station/city names — used as subtitle
                        final originCity = _localizedField(
                          trip,
                          isArabic: isArabic,
                          key: 'origin',
                          arabicKeys: const [
                            'originAr',
                            'originStationNameAr',
                            'originNameAr',
                          ],
                        );
                        final destinationCity = _localizedField(
                          trip,
                          isArabic: isArabic,
                          key: 'destination',
                          arabicKeys: const [
                            'destinationAr',
                            'destinationStationNameAr',
                            'destinationNameAr',
                          ],
                        );
                        final agencyName = _localizedField(
                          trip,
                          isArabic: isArabic,
                          key: 'agencyName',
                          arabicKeys: const ['agencyNameAr', 'agencyAr'],
                          fallback: _localizedField(
                            item,
                            isArabic: isArabic,
                            key: 'agencyName',
                            arabicKeys: const ['agencyNameAr', 'agencyAr'],
                            fallback: item['agency'] as String?,
                          ),
                        );
                        final className = _localizedField(
                          trip,
                          isArabic: isArabic,
                          key: 'class',
                          arabicKeys: const ['classNameAr', 'classAr'],
                          fallback: l10n.standardClass,
                        );

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
                            ? ((newPrice - oldPrice) / oldPrice * 100).round()
                            : 0;
                        final percentageLabel = discountVal > 0
                            ? '+$discountVal%'
                            : '$discountVal%';

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
                            className: _cleanClassName(className),
                            sellerName:
                                item['sellerName'] as String? ??
                                l10n.sellerLabel,
                            agencyName: agencyName,
                            oldPrice:
                                '${oldPrice.toStringAsFixed(2)} ${l10n.egp}',
                            newPrice:
                                '${newPrice.toStringAsFixed(2)} ${l10n.egp}',
                            discount: percentageLabel,
                            forSaleLabel: l10n.availableForSale,
                            classLabel: l10n.classLabel,
                            sellerLabel: l10n.sellerLabel,
                            buyNowLabel: l10n.buyNow,
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
    int validCount = 0;
    for (final l in listings) {
      final item = l as Map<String, dynamic>;
      final old = (item['originalPrice'] as num? ?? 0).toDouble();
      final ask = (item['askingPrice'] as num? ?? 0).toDouble();
      if (old > 0) {
        sum += (ask - old) / old * 100;
        validCount++;
      }
    }
    if (validCount == 0) return '—';
    final avg = (sum / validCount).round();
    return avg > 0 ? '+$avg%' : '$avg%';
  }

  /// Removes duplicate agency prefix from class names.
  /// e.g. "GoBus - GoBus - GoMini" → "GoBus - GoMini"
  String _cleanClassName(String raw) {
    final parts = raw.split(' - ');
    final seen = <String>{};
    final deduped = parts.where((p) => seen.add(p.trim())).toList();
    return deduped.join(' - ');
  }

  String _localizedField(
    Map<String, dynamic> source, {
    required bool isArabic,
    required String key,
    required List<String> arabicKeys,
    String? fallback,
  }) {
    if (isArabic) {
      for (final arabicKey in arabicKeys) {
        final value = source[arabicKey]?.toString().trim();
        if (value != null && value.isNotEmpty) return value;
      }
    }

    final original = source[key]?.toString().trim();
    if (original != null && original.isNotEmpty) return original;
    return fallback?.trim() ?? '';
  }

  void _showBuyDialog(
    BuildContext context,
    Map<String, dynamic> item,
    MarketplaceCubit cubit,
  ) {
    final trip = item['tripDetails'] as Map<String, dynamic>? ?? {};
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    // Correct API field names
    final originGov = _localizedField(
      trip,
      isArabic: isArabic,
      key: 'originGov',
      arabicKeys: const ['originGovAr', 'originGovernorateAr'],
    );
    final destinationGov = _localizedField(
      trip,
      isArabic: isArabic,
      key: 'destinationGov',
      arabicKeys: const ['destinationGovAr', 'destinationGovernorateAr'],
    );
    final originCity = _localizedField(
      trip,
      isArabic: isArabic,
      key: 'origin',
      arabicKeys: const ['originAr', 'originStationNameAr', 'originNameAr'],
    );
    final destinationCity = _localizedField(
      trip,
      isArabic: isArabic,
      key: 'destination',
      arabicKeys: const [
        'destinationAr',
        'destinationStationNameAr',
        'destinationNameAr',
      ],
    );
    final agencyName = _localizedField(
      trip,
      isArabic: isArabic,
      key: 'agencyName',
      arabicKeys: const ['agencyNameAr', 'agencyAr'],
      fallback: _localizedField(
        item,
        isArabic: isArabic,
        key: 'agencyName',
        arabicKeys: const ['agencyNameAr', 'agencyAr'],
        fallback: item['agency'] as String?,
      ),
    );
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
    final className = _cleanClassName(
      _localizedField(
        trip,
        isArabic: isArabic,
        key: 'class',
        arabicKeys: const ['classNameAr', 'classAr'],
        fallback: AppLocalizations.of(context)!.standardClass,
      ),
    );
    final newPrice = (item['askingPrice'] as num? ?? 0).toDouble();

    showDialog(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          backgroundColor: ColorsManager.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.shopping_cart,
                color: ColorsManager.accentCyan,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.buyTicket,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l10n.agencyLabel}: ${agencyName.isEmpty ? l10n.unknown : agencyName}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                if (originDisplay.isNotEmpty)
                  Text(
                    '${l10n.originLabel}: $originDisplay',
                    style: const TextStyle(color: Colors.white70),
                  ),
                if (destinationDisplay.isNotEmpty)
                  Text(
                    '${l10n.destinationLabel}: $destinationDisplay',
                    style: const TextStyle(color: Colors.white70),
                  ),
                const SizedBox(height: 8),
                Text(
                  '${l10n.dateLabel}: ${dt.day}/${dt.month}/${dt.year}',
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  '${l10n.timeLabel}: ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  '${l10n.classLabel}: $className',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  '${l10n.priceLabel}: ${newPrice.toStringAsFixed(2)} ${l10n.egp}',
                  style: const TextStyle(
                    color: ColorsManager.successGreen,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.areYouSureBuyTicket,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                l10n.cancel,
                style: const TextStyle(color: Colors.white38),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(
                  context,
                  AppRoutes.marketplacePassengerFormScreen,
                  arguments: {'item': item, 'cubit': cubit},
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.successGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                l10n.buyNow,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
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
        color: ColorsManager.accentCyan.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorsManager.accentCyan.withValues(alpha: 0.4),
        ),
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
