import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/booking/domain/entities/cart_entity.dart';
import 'package:transportation_app/features/booking/presentation/cubit/cart_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/cart_state.dart';

class CartItemCard extends StatelessWidget {
  final CartItemEntity item;

  const CartItemCard({super.key, required this.item});

  Color get _agencyColor {
    final name = item.agencyName.toLowerCase();
    if (name.contains('gobus')) return ColorsManager.agencyGoBus;
    if (name.contains('blue')) return ColorsManager.agencyBlueBus;
    if (name.contains('rail') ||
        name.contains('train') ||
        name.contains('enr')) {
      return ColorsManager.agencyRailway;
    }
    if (name.contains('horus')) return ColorsManager.agencyHorus;
    return ColorsManager.accentCyan;
  }

  String _localizedValue(
    String english,
    String arabic,
    bool isArabic, {
    String fallback = '',
  }) {
    final preferred = isArabic ? arabic : english;
    final backup = isArabic ? english : arabic;
    if (preferred.trim().isNotEmpty) return preferred;
    if (backup.trim().isNotEmpty) return backup;
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final agencyName = _localizedValue(
      item.agencyName,
      item.agencyNameAr,
      isArabic,
      fallback: l10n.unknown,
    );
    final originStation = _localizedValue(item.origin, item.originAr, isArabic);
    final destinationStation = _localizedValue(
      item.destination,
      item.destinationAr,
      isArabic,
    );
    final originTitle = _localizedValue(
      item.originGov,
      item.originGovAr,
      isArabic,
      fallback: originStation.isNotEmpty ? originStation : l10n.unknown,
    );
    final destinationTitle = _localizedValue(
      item.destinationGov,
      item.destinationGovAr,
      isArabic,
      fallback: destinationStation.isNotEmpty
          ? destinationStation
          : l10n.unknown,
    );
    final className = _localizedValue(
      item.className,
      item.classNameAr,
      isArabic,
      fallback: l10n.standardClass,
    );
    final stationSubtitle = [
      originStation,
      destinationStation,
    ].where((value) => value.trim().isNotEmpty).join('  •  ');

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: ColorsManager.cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: ColorsManager.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(45),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _AgencyBadge(label: agencyName, color: _agencyColor),
                    _PriceBadge(price: item.totalPrice),
                  ],
                ),
                const SizedBox(height: 16),
                _RouteTitle(
                  origin: originTitle,
                  destination: destinationTitle,
                  isRtl: isArabic,
                ),
                if (stationSubtitle.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    stationSubtitle,
                    style: const TextStyle(
                      color: ColorsManager.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 16),
                _DetailListRow(
                  icon: Icons.calendar_today_outlined,
                  label: l10n.departure,
                  value: _formatDeparture(context, item.boardingTime),
                ),
                _DetailListRow(
                  icon: Icons.computer_outlined,
                  label: l10n.classLabel,
                  value: '$agencyName - $className',
                ),
                _DetailListRow(
                  icon: Icons.timer_outlined,
                  label: l10n.expires,
                  value: _formatExpiry(context, item.holdExpiresAt),
                  isWarning: true,
                ),
              ],
            ),
          ),
          _PassengersStrip(item: item),
        ],
      ),
    );
  }

  String _formatDeparture(BuildContext context, DateTime? value) {
    if (value == null) return AppLocalizations.of(context)!.unknown;
    return DateFormat(
      'MMM dd, HH:mm',
      Localizations.localeOf(context).toString(),
    ).format(value);
  }

  String _formatExpiry(BuildContext context, DateTime? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null) return l10n.unknown;
    final diff = value.difference(DateTime.now());
    if (diff.isNegative) return l10n.expired;
    return '${diff.inMinutes}m';
  }
}

class _AgencyBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _AgencyBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withAlpha(90)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 6),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}

class _RouteTitle extends StatelessWidget {
  final String origin;
  final String destination;
  final bool isRtl;

  const _RouteTitle({
    required this.origin,
    required this.destination,
    required this.isRtl,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: origin,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  isRtl ? Icons.arrow_back : Icons.arrow_forward,
                  color: ColorsManager.accentCyan,
                  size: 18,
                ),
              ),
            ),
            TextSpan(
              text: destination,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  final double price;

  const _PriceBadge({required this.price});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ColorsManager.accentCyan.withAlpha(20),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: ColorsManager.accentCyan.withAlpha(90)),
      ),
      child: Text(
        '${price.toStringAsFixed(1)} ${l10n.egp}',
        style: const TextStyle(
          color: ColorsManager.accentCyan,
          fontSize: 13,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _DetailListRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isWarning;

  const _DetailListRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isWarning ? Colors.redAccent : ColorsManager.textMuted;
    final valueColor = isWarning ? Colors.redAccent : Colors.white;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _PassengersStrip extends StatelessWidget {
  final CartItemEntity item;

  const _PassengersStrip({required this.item});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.fromLTRB(16, 0, 10, 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        iconColor: ColorsManager.accentCyan,
        collapsedIconColor: ColorsManager.textMuted,
        title: Row(
          children: [
            const Icon(
              Icons.person_outline,
              color: ColorsManager.textMuted,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.passengersCount(item.seatsBooked.toString()),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                final isCancelling =
                    state is CartItemCancelling &&
                    state.bookingId == item.bookingId;
                if (isCancelling) {
                  return const SizedBox(
                    width: 32,
                    height: 32,
                    child: Padding(
                      padding: EdgeInsets.all(6.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.redAccent,
                      ),
                    ),
                  );
                }
                return Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    tooltip: l10n.cancelTripBtn,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 16,
                    ),
                    onPressed: () => _confirmCancel(context, item.bookingId),
                    padding: EdgeInsets.zero,
                  ),
                );
              },
            ),
          ],
        ),
        children: item.passengers.map((p) => _PassengerRow(p: p)).toList(),
      ),
    );
  }

  void _confirmCancel(BuildContext context, int bookingId) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: ColorsManager.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.cancelTripTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          l10n.cancelTripMsg,
          style: const TextStyle(color: Colors.white60),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.keepIt,
              style: const TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CartCubit>().cancelItem(bookingId);
            },
            child: Text(
              l10n.cancelTripBtn,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PassengerRow extends StatelessWidget {
  final CartPassengerEntity p;

  const _PassengerRow({required this.p});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ColorsManager.surfaceMid,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorsManager.borderDim),
            ),
            child: Text(
              p.seatNumber.isNotEmpty ? p.seatNumber : '-',
              style: const TextStyle(
                color: ColorsManager.accentCyan,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name.isNotEmpty ? p.name : l10n.unknown,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  p.idNumber.isNotEmpty ? l10n.idNum(p.idNumber) : l10n.unknown,
                  style: const TextStyle(
                    color: ColorsManager.textMuted,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
