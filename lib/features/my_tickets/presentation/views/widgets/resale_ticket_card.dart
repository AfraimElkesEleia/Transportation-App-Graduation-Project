import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/my_tickets/domain/entities/ticket_entity.dart';

/// A card summarising a [TicketEntity] for the resell screen.
///
/// Displays route, date/time, per-passenger seat details, and a
/// Sell / Cancel action button driven by [ticket.isOfferedForResale].
class ResaleTicketCard extends StatelessWidget {
  final TicketEntity ticket;

  /// Called when the user taps "Sell" (ticket is not yet listed).
  final VoidCallback? onSell;

  /// Called when the user taps "Cancel" (ticket is already listed).
  final VoidCallback? onCancel;

  /// When true, replaces the action button with a small spinner.
  final bool isPending;

  const ResaleTicketCard({
    super.key,
    required this.ticket,
    this.onSell,
    this.onCancel,
    this.isPending = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dt = ticket.boardingTime;
    final daysLeft = dt.difference(DateTime.now()).inDays;
    final timeStr =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    final dateStr = '${dt.day}/${dt.month}/${dt.year}';
    final fromTo =
        '${ticket.originStation.isNotEmpty ? ticket.originStation : ticket.originGovernorate}'
        ' → '
        '${ticket.destinationStation.isNotEmpty ? ticket.destinationStation : ticket.destinationGovernorate}';

    final isListed = ticket.isOfferedForResale;
    final totalPrice = ticket.totalPrice;
    final estValue = (totalPrice * 0.8).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.resellCardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isListed
              ? Colors.orange.withValues(alpha: 0.4)
              : ColorsManager.accentCyan.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Route & Days left ─────────────────────────────────────────
          Row(
            children: [
              const Icon(
                Icons.directions_bus_rounded,
                color: ColorsManager.accentCyan,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  fromTo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: daysLeft < 3
                      ? Colors.redAccent.withValues(alpha: 0.15)
                      : ColorsManager.accentCyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: daysLeft < 3
                        ? Colors.redAccent.withValues(alpha: 0.4)
                        : ColorsManager.accentCyan.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  l10n.daysLeft(daysLeft.toString()),
                  style: TextStyle(
                    color: daysLeft < 3
                        ? Colors.redAccent
                        : ColorsManager.accentCyan,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Date & Time ───────────────────────────────────────────────
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 13,
                color: Colors.white54,
              ),
              const SizedBox(width: 4),
              Text(
                dateStr,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(width: 14),
              const Icon(
                Icons.access_time_rounded,
                size: 13,
                color: Colors.white54,
              ),
              const SizedBox(width: 4),
              Text(
                timeStr,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Divider(color: Colors.white.withValues(alpha: 0.07), height: 1),
          const SizedBox(height: 12),

          // ── Marketplace status banner ─────────────────────────────────
          if (isListed)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.storefront, color: Colors.amber, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    l10n.listedOnMarketplace,
                    style: const TextStyle(color: Colors.amber, fontSize: 12),
                  ),
                ],
              ),
            ),

          // ── Passenger seat list (display only) ───────────────────────
          ...ticket.passengers.map((p) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.event_seat,
                    size: 16,
                    color: ColorsManager.accentCyan,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${l10n.seat} ${p.seatNumber}  ·  ${p.name}',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 4),

          // ── Price & Action button ─────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n.totalPrice} ${totalPrice.round()} ${l10n.egp}',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          '~$estValue EGP',
                          style: const TextStyle(
                            color: ColorsManager.successGreen,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: ColorsManager.successGreen.withValues(
                              alpha: 0.12,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            l10n.estValue,
                            style: const TextStyle(
                              color: ColorsManager.successGreen,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Action button
              if (isPending)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ColorsManager.accentCyan,
                  ),
                )
              else if (isListed)
                ElevatedButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.cancel_outlined, size: 15),
                  label: Text(
                    l10n.cancel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                )
              else
                ElevatedButton.icon(
                  onPressed: onSell,
                  icon: const Icon(Icons.sell_outlined, size: 15),
                  label: Text(
                    l10n.sell,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: onSell != null
                        ? ColorsManager.successGreen
                        : Colors.grey.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
