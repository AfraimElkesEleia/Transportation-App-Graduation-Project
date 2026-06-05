import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/booking/domain/entities/cart_entity.dart';
import 'package:transportation_app/features/booking/presentation/cubit/cart_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/cart_state.dart';

class CartItemCard extends StatelessWidget {
  final CartItemEntity item;

  const CartItemCard({super.key, required this.item});

  Color get _agencyColor {
    final n = item.agencyName.toLowerCase();
    if (n.contains('gobus')) return ColorsManager.agencyGoBus;
    if (n.contains('blue')) return ColorsManager.agencyBlueBus;
    if (n.contains('rail') || n.contains('train') || n.contains('enr'))
      return ColorsManager.agencyRailway;
    if (n.contains('horus')) return ColorsManager.agencyHorus;
    return ColorsManager.agencyDefault;
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
    final originGov = _localizedValue(
      item.originGov,
      item.originGovAr,
      isArabic,
    );
    final originStation = _localizedValue(item.origin, item.originAr, isArabic);
    final destinationGov = _localizedValue(
      item.destinationGov,
      item.destinationGovAr,
      isArabic,
    );
    final destinationStation = _localizedValue(
      item.destination,
      item.destinationAr,
      isArabic,
    );
    final originTitle = originGov.isNotEmpty ? originGov : originStation;
    final destinationTitle = destinationGov.isNotEmpty
        ? destinationGov
        : destinationStation;
    final stationSubtitle = [
      originStation,
      destinationStation,
    ].where((value) => value.isNotEmpty).join('  •  ');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: ColorsManager.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsManager.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ──────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _agencyColor.withAlpha(30),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              border: Border(
                bottom: BorderSide(color: _agencyColor.withAlpha(50)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Agency chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _agencyColor.withAlpha(50),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: _agencyColor.withAlpha(120),
                          ),
                        ),
                        child: Text(
                          agencyName,
                          style: TextStyle(
                            color: _agencyColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Row 1: gov → gov (large)
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              originTitle.isNotEmpty
                                  ? originTitle
                                  : l10n.unknown,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.arrow_forward,
                              color: ColorsManager.accentCyan,
                              size: 14,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              destinationTitle.isNotEmpty
                                  ? destinationTitle
                                  : l10n.unknown,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      // Row 2: Arabic station names (muted)
                      if (stationSubtitle.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            stationSubtitle,
                            style: const TextStyle(
                              color: ColorsManager.textMuted,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: ColorsManager.accentCyan.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: ColorsManager.accentCyan.withAlpha(76),
                    ),
                  ),
                  child: Text(
                    '${item.totalPrice} ${l10n.egp}',
                    style: const TextStyle(
                      color: ColorsManager.accentCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeInfo(
                  context,
                  icon: Icons.departure_board,
                  label: l10n.departure,
                  time: item.boardingTime,
                ),
                _buildTimeInfo(
                  context,
                  icon: Icons.event_seat,
                  label: l10n.classLabel,
                  text: _localizedValue(
                    item.className,
                    item.classNameAr,
                    isArabic,
                    fallback: l10n.standardClass,
                  ),
                ),
                _buildTimeInfo(
                  context,
                  icon: Icons.timer,
                  label: l10n.expires,
                  time: item.holdExpiresAt,
                  isWarning: true,
                ),
              ],
            ),
          ),

          // Passengers Expansion & Cancel Button
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              iconColor: ColorsManager.accentCyan,
              collapsedIconColor: ColorsManager.textMuted,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.passengersCount(item.seatsBooked.toString()),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                      bool isCancelling =
                          state is CartItemCancelling &&
                          state.bookingId == item.bookingId;
                      return isCancelling
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.red,
                              ),
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                              onPressed: () =>
                                  _confirmCancel(context, item.bookingId),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            );
                    },
                  ),
                ],
              ),
              children: item.passengers
                  .map((p) => _buildPassengerRow(context, p))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo(
    BuildContext context, {
    required IconData icon,
    required String label,
    DateTime? time,
    String? text,
    bool isWarning = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    String display = (text != null && text.trim().isNotEmpty)
        ? text
        : l10n.unknown;
    if (time != null) {
      if (isWarning) {
        final diff = time.difference(DateTime.now());
        if (diff.isNegative) {
          display = l10n.expired;
        } else {
          display = '${diff.inMinutes}m';
        }
      } else {
        display = DateFormat(
          'MMM dd, hh:mm a',
          Localizations.localeOf(context).toString(),
        ).format(time);
      }
    }

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: isWarning ? Colors.redAccent : ColorsManager.textMuted,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: ColorsManager.textMuted,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            display,
            style: TextStyle(
              color: isWarning ? Colors.redAccent : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerRow(BuildContext context, CartPassengerEntity p) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: ColorsManager.seatContainerBg,
            child: Text(
              p.seatNumber.isNotEmpty ? p.seatNumber : '-',
              style: const TextStyle(
                color: ColorsManager.accentCyan,
                fontSize: 12,
                fontWeight: FontWeight.bold,
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
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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
