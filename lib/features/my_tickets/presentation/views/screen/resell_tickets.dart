import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/utils/localized_time_formatter.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/marketplace_cubit.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/marketplace_states.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/my_tickets_cubit.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/my_tickets_states.dart';
import 'package:transportation_app/features/my_tickets/domain/entities/ticket_entity.dart';

class ResellTicketsScreen extends StatefulWidget {
  const ResellTicketsScreen({super.key});

  @override
  State<ResellTicketsScreen> createState() => _ResellTicketsScreenState();
}

class _ResellTicketsScreenState extends State<ResellTicketsScreen> {
  /// Key of the ticket currently being processed (listing/cancelling).
  String? _pendingTicketKey;

  @override
  void initState() {
    super.initState();
    context.read<MyTicketsCubit>().fetchTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.resellPrimaryBg,
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
              AppLocalizations.of(context)!.resellTickets,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.turnTicketsIntoCash,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: BlocConsumer<MarketplaceCubit, MarketplaceState>(
        listenWhen: (_, current) =>
            current is MarketplaceListedState ||
            current is MarketplaceListErrorState,
        listener: (context, state) {
          setState(() => _pendingTicketKey = null);
          if (state is MarketplaceListedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.listingUpdated),
                backgroundColor: Colors.green,
              ),
            );
            context.read<MyTicketsCubit>().fetchTickets();
          } else if (state is MarketplaceListErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, marketState) {
          final isMktBusy = marketState is MarketplaceListingState;

          return BlocBuilder<MyTicketsCubit, MyTicketsState>(
            builder: (context, ticketState) {
              // Show spinner on first load
              if (ticketState is TicketsLoadingState &&
                  context.read<MyTicketsCubit>().cachedTickets.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: ColorsManager.accentCyan,
                  ),
                );
              }

              final allTickets = (ticketState is TicketsLoadedState
                  ? ticketState.tickets
                  : context.read<MyTicketsCubit>().cachedTickets);
              for (final t in allTickets) {
                debugPrint(
                  'Ticket ${t.bookingId} → isMarketplacePurchase: ${t.isMarketplacePurchase}',
                );
              }
              debugPrint('State: $ticketState');
              debugPrint('Using cached: ${ticketState is! TicketsLoadedState}');
              for (final t in allTickets) {
                debugPrint(
                  'Widget sees → ${t.bookingId}: isMarketplacePurchase=${t.isMarketplacePurchase}',
                );
              }
              // Only upcoming + confirmed + NOT a marketplace purchase
              // + refund must NOT be in progress or accepted
              final resellableTickets = allTickets
                  .where(
                    (t) =>
                        t.isUpcoming &&
                        !t.isMarketplacePurchase &&
                        t.status == 'Confirmed' &&
                        (t.refundStatus == null ||
                            t.refundStatus == 'Rejected'),
                  )
                  .toList()
                ..sort((a, b) {
                  final boardingTimeCompare = a.boardingTime.compareTo(
                    b.boardingTime,
                  );
                  if (boardingTimeCompare != 0) return boardingTimeCompare;

                  return a.bookingId.compareTo(b.bookingId);
                });
              debugPrint('Resellable count: ${resellableTickets.length}');
              for (final t in resellableTickets) {
                debugPrint(
                  'Resellable → ${t.bookingId}: isMarketplacePurchase=${t.isMarketplacePurchase}, isUpcoming=${t.isUpcoming}, status=${t.status}',
                );
              }
              return RefreshIndicator(
                color: ColorsManager.accentCyan,
                backgroundColor: ColorsManager.cardBg,
                onRefresh: () => context.read<MyTicketsCubit>().fetchTickets(),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // ── Stats row ──────────────────────────────────────────
                    _StatsRow(tickets: resellableTickets),
                    const SizedBox(height: 20),

                    // ── Section header ─────────────────────────────────────
                    Row(
                      children: [
                        const Icon(
                          Icons.sell_outlined,
                          color: ColorsManager.accentCyan,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.yourUpcomingTickets,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Error banner ───────────────────────────────────────
                    if (ticketState is TicketsErrorState)
                      _ErrorBanner(
                        message: ticketState.message,
                        onRetry: () =>
                            context.read<MyTicketsCubit>().fetchTickets(),
                      ),

                    // ── Empty state ────────────────────────────────────────
                    if (resellableTickets.isEmpty &&
                        ticketState is! TicketsLoadingState)
                      const _EmptyState(),

                    // ── Ticket cards ───────────────────────────────────────
                    ...resellableTickets.map((ticket) {
                      final key = '${ticket.bookingId}';
                      final isPending = _pendingTicketKey == key;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ResellTicketCard(
                          ticket: ticket,
                          isPending: isPending || isMktBusy,
                          onSell: () => _showSellDialog(context, ticket, key),
                          onCancel: () =>
                              _showCancelDialog(context, ticket, key),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ── Sell dialog ─────────────────────────────────────────────────────────────
  void _showSellDialog(
    BuildContext context,
    TicketEntity ticket,
    String ticketKey,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final display = _localizedTicketValues(ticket, context.isArabic);
    final priceCtrl = TextEditingController(
      text: ticket.totalPrice.round().toString(),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ColorsManager.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(
              Icons.sell_outlined,
              color: ColorsManager.accentCyan,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.listTicketForSale,
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Route info
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _RouteSummary(
                      originGovernorate: display.originGovernorate,
                      destinationGovernorate: display.destinationGovernorate,
                      originStation: display.originStation,
                      destinationStation: display.destinationStation,
                      compact: true,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${l10n.seatsCount(ticket.seatsBooked.toString())} · ${display.agencyName}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      l10n.originalPrice(
                        ticket.totalPrice.round().toString(),
                        l10n.egp,
                      ),
                      style: const TextStyle(
                        color: ColorsManager.accentCyan,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.askingPrice,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                  suffixText: l10n.egp,
                  suffixStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: ColorsManager.accentCyan,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: Colors.white38),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final price = double.tryParse(priceCtrl.text.trim()) ?? 0.0;
              Navigator.pop(ctx);
              setState(() => _pendingTicketKey = ticketKey);
              context.read<MarketplaceCubit>().listTicket(
                bookingId: ticket.bookingId,
                askingPrice: price,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManager.successGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.sell,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Cancel dialog ───────────────────────────────────────────────────────────
  void _showCancelDialog(
    BuildContext context,
    TicketEntity ticket,
    String ticketKey,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ColorsManager.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.cancelListing,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Text(
          AppLocalizations.of(context)!.cancelListingPrompt,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              AppLocalizations.of(context)!.no,
              style: const TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _pendingTicketKey = ticketKey);
              context.read<MarketplaceCubit>().cancelListing(
                listingId: ticket.marketplaceListingId ?? 0,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: Text(
              AppLocalizations.of(context)!.cancelListing,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stats row ─────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final List<TicketEntity> tickets;
  const _StatsRow({required this.tickets});

  @override
  Widget build(BuildContext context) {
    final listed = tickets.where((t) => t.isOfferedForResale).length;
    final totalValue = tickets.fold<double>(0, (sum, t) => sum + t.totalPrice);

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.confirmation_number_outlined,
            label: AppLocalizations.of(context)!.available,
            value: '${tickets.length}',
            color: ColorsManager.accentCyan,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.storefront_outlined,
            label: AppLocalizations.of(context)!.listed,
            value: '$listed',
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.trending_up,
            label: AppLocalizations.of(context)!.estValue,
            value: '${totalValue.round()} ${AppLocalizations.of(context)!.egp}',
            color: ColorsManager.successGreen,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: ColorsManager.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// ── Ticket card ───────────────────────────────────────────────────────────────
class _ResellTicketCard extends StatelessWidget {
  final TicketEntity ticket;
  final bool isPending;
  final VoidCallback onSell;
  final VoidCallback onCancel;

  const _ResellTicketCard({
    required this.ticket,
    required this.isPending,
    required this.onSell,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isListed = ticket.isOfferedForResale;
    final display = _localizedTicketValues(ticket, context.isArabic);
    final locale = Localizations.localeOf(context).languageCode;
    final date = DateFormat(
      'EEE, dd MMM yyyy',
      locale,
    ).format(ticket.boardingTime);
    final time = formatTicketTime(context, ticket.boardingTime);
    final daysLeft = ticket.boardingTime.difference(DateTime.now()).inDays;

    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isListed
              ? Colors.orange.withValues(alpha: 0.5)
              : ColorsManager.accentCyan.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isListed
                  ? Colors.orange.withValues(alpha: 0.15)
                  : ColorsManager.accentCyan.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isListed
                      ? Icons.storefront
                      : Icons.confirmation_number_outlined,
                  color: isListed ? Colors.orange : ColorsManager.accentCyan,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isListed
                        ? AppLocalizations.of(context)!.listedOnMarketplace
                        : AppLocalizations.of(context)!.availableForSale,
                    style: TextStyle(
                      color: isListed
                          ? Colors.orange
                          : ColorsManager.accentCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                // Days badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: daysLeft < 3
                        ? Colors.redAccent.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    l10n.daysLeft(daysLeft.toString()),
                    style: TextStyle(
                      color: daysLeft < 3 ? Colors.redAccent : Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Route
                _RouteSummary(
                  originGovernorate: display.originGovernorate,
                  destinationGovernorate: display.destinationGovernorate,
                  originStation: display.originStation,
                  destinationStation: display.destinationStation,
                ),
                const SizedBox(height: 8),

                // Meta row
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    _MetaChip(icon: Icons.calendar_today, label: date),
                    _MetaChip(icon: Icons.access_time, label: time),
                    _MetaChip(
                      icon: Icons.event_seat,
                      label: l10n.seatsCount(ticket.seatsBooked.toString()),
                    ),
                    _MetaChip(
                      icon: Icons.directions_bus,
                      label: display.agencyName,
                    ),
                    _MetaChip(
                      icon: Icons.airline_seat_recline_normal_outlined,
                      label: display.className,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Price
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.totalPrice,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${ticket.totalPrice.round()} ${l10n.egp}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    // Action button
                    isPending
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: ColorsManager.accentCyan,
                            ),
                          )
                        : ElevatedButton.icon(
                            onPressed: isListed ? onCancel : onSell,
                            icon: Icon(
                              isListed ? Icons.cancel_outlined : Icons.sell,
                              size: 16,
                            ),
                            label: Text(
                              isListed
                                  ? AppLocalizations.of(context)!.cancel
                                  : AppLocalizations.of(context)!.sell,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isListed
                                  ? Colors.redAccent
                                  : ColorsManager.successGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteSummary extends StatelessWidget {
  final String originGovernorate;
  final String destinationGovernorate;
  final String originStation;
  final String destinationStation;
  final bool compact;

  const _RouteSummary({
    required this.originGovernorate,
    required this.destinationGovernorate,
    required this.originStation,
    required this.destinationStation,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final showOriginStation = _isDifferent(originStation, originGovernorate);
    final showDestinationStation = _isDifferent(
      destinationStation,
      destinationGovernorate,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                originGovernorate,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: compact ? 14 : 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.arrow_forward,
                color: ColorsManager.accentCyan,
                size: 16,
              ),
            ),
            Expanded(
              child: Text(
                destinationGovernorate,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: compact ? 14 : 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        if (showOriginStation || showDestinationStation) ...[
          SizedBox(height: compact ? 4 : 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  showOriginStation ? originStation : '',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.58),
                    fontSize: compact ? 11 : 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.more_horiz, color: Colors.white30, size: 16),
              ),
              Expanded(
                child: Text(
                  showDestinationStation ? destinationStation : '',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.58),
                    fontSize: compact ? 11 : 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  bool _isDifferent(String value, String comparison) {
    return value.trim().isNotEmpty &&
        value.trim().toLowerCase() != comparison.trim().toLowerCase();
  }
}

class _LocalizedTicketValues {
  final String agencyName;
  final String className;
  final String originGovernorate;
  final String originStation;
  final String destinationGovernorate;
  final String destinationStation;

  const _LocalizedTicketValues({
    required this.agencyName,
    required this.className,
    required this.originGovernorate,
    required this.originStation,
    required this.destinationGovernorate,
    required this.destinationStation,
  });
}

_LocalizedTicketValues _localizedTicketValues(TicketEntity ticket, bool isAr) {
  return _LocalizedTicketValues(
    agencyName: _localizedValue(ticket.agencyName, ticket.agencyNameAr, isAr),
    className: _localizedValue(ticket.className, ticket.classNameAr, isAr),
    originGovernorate: _localizedValue(
      ticket.originGovernorate,
      ticket.originGovernorateAr,
      isAr,
    ),
    originStation: _localizedValue(
      ticket.originStation,
      ticket.originStationNameAr,
      isAr,
    ),
    destinationGovernorate: _localizedValue(
      ticket.destinationGovernorate,
      ticket.destinationGovernorateAr,
      isAr,
    ),
    destinationStation: _localizedValue(
      ticket.destinationStation,
      ticket.destinationStationNameAr,
      isAr,
    ),
  );
}

String _localizedValue(String original, String? localized, bool useLocalized) {
  if (useLocalized && localized != null && localized.trim().isNotEmpty) {
    return localized.trim();
  }
  return original.trim();
}

// ── Meta chip ──────────────────────────────────────────────────────────────────
class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white38, size: 12),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Icon(
              Icons.confirmation_number_outlined,
              size: 64,
              color: Colors.white.withValues(alpha: 0.1),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noResellable,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.resellRules,
              style: const TextStyle(color: Colors.white30, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error banner ──────────────────────────────────────────────────────────────
class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorBanner({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            color: Colors.redAccent,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              AppLocalizations.of(context)!.retry,
              style: const TextStyle(color: ColorsManager.accentCyan),
            ),
          ),
        ],
      ),
    );
  }
}
