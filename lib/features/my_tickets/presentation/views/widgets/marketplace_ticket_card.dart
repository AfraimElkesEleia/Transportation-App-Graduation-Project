import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';

/// A card displaying a marketplace ticket listing.
///
/// Redesigned to handle long Arabic station names and long class strings
/// without overflow — all text uses Expanded/Flexible and ellipsis clipping.
class MarketplaceTicketCard extends StatelessWidget {
  final String fromTo;
  final String date;
  final String time;
  final String className;
  final String sellerName;
  final String oldPrice;
  final String newPrice;
  final String discount;
  final VoidCallback onBuy;
  final String? fromLocation;
  final String? toLocation;
  final String? originGov;
  final String? destinationGov;
  final String? agencyName;
  final String forSaleLabel;
  final String classLabel;
  final String sellerLabel;
  final String buyNowLabel;

  const MarketplaceTicketCard({
    super.key,
    required this.fromTo,
    required this.date,
    required this.time,
    required this.className,
    required this.sellerName,
    required this.oldPrice,
    required this.newPrice,
    required this.discount,
    required this.onBuy,
    this.fromLocation,
    this.toLocation,
    this.originGov,
    this.destinationGov,
    this.agencyName,
    required this.forSaleLabel,
    required this.classLabel,
    required this.sellerLabel,
    required this.buyNowLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.marketplaceCardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorsManager.accentCyan.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Agency Label ──────────────────────────────────────────────
          if (agencyName != null && agencyName!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  agencyName!,
                  style: const TextStyle(
                    color: ColorsManager.accentCyan,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // ── Route header ──────────────────────────────────────────────
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textDirection: Directionality.of(context),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: ColorsManager.successGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ColorsManager.successGreen.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  forSaleLabel,
                  style: const TextStyle(
                    color: ColorsManager.successGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // ── Governorate-to-governorate line ───────────────────────────
          if (originGov != null || destinationGov != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 13,
                    color: ColorsManager.accentCyan,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      originGov ?? '',
                      style: const TextStyle(
                        color: ColorsManager.accentCyan,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 12,
                      color: Colors.white38,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      destinationGov ?? '',
                      style: const TextStyle(
                        color: ColorsManager.accentCyan,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),

          // ── Station detail line ───────────────────────────────────────
          if (fromLocation != null || toLocation != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                '${fromLocation ?? ''}${fromLocation != null && toLocation != null ? ' • ' : ''}${toLocation ?? ''}',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),

          // ── Date & time ───────────────────────────────────────────────
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 13,
                color: Colors.white54,
              ),
              const SizedBox(width: 4),
              Text(
                date,
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
                time,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Divider ───────────────────────────────────────────────────
          Divider(color: Colors.white.withValues(alpha: 0.07), height: 1),
          const SizedBox(height: 12),

          // ── Class & Seller row (two items, each Expanded) ─────────────
          Row(
            children: [
              Expanded(
                child: _LabelValue(
                  label: classLabel,
                  value: className,
                  icon: Icons.airline_seat_recline_normal_outlined,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _LabelValue(
                  label: sellerLabel,
                  value: sellerName,
                  icon: Icons.person_outline_rounded,
                  accent: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Pricing & buy button ──────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Price block
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      oldPrice,
                      style: const TextStyle(
                        color: Colors.white38,
                        decoration: TextDecoration.lineThrough,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          newPrice,
                          style: const TextStyle(
                            color: ColorsManager.successGreen,
                            fontSize: 22,
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
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            discount,
                            style: const TextStyle(
                              color: ColorsManager.successGreen,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Buy button
              ElevatedButton.icon(
                onPressed: onBuy,
                icon: const Icon(Icons.shopping_cart_outlined, size: 16),
                label: Text(
                  buyNowLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.successGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 11,
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

class _LabelValue extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool accent;

  const _LabelValue({
    required this.label,
    required this.value,
    required this.icon,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: accent ? ColorsManager.accentCyan : Colors.white54,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white38, fontSize: 10),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: accent ? ColorsManager.accentCyan : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
