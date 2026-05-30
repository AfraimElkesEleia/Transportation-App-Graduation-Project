import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/profile/domain/entities/point_transaction.dart';

class PointTransactionTile extends StatelessWidget {
  final PointTransaction transaction;

  const PointTransactionTile({super.key, required this.transaction});

  /// Maps raw API source strings to localized display labels.
  String _localizeSource(String source, AppLocalizations loc) {
    switch (source) {
      case 'ChallengeReward':
        return loc.txChallengeReward;
      case 'BookingEarned':
        return loc.txBookingEarned;
      case 'Deposit':
        return loc.txDeposit;
      case 'TicketPurchase':
        return loc.txTicketPurchase;
      case 'Redemption':
        return loc.txRedemption;
      case 'Reward':
        return loc.txReward;
      default:
        return source;
    }
  }

  /// Maps raw API status strings to localized display labels.
  String _localizeStatus(String status, AppLocalizations loc) {
    switch (status) {
      case 'Available':
        return loc.txStatusAvailable;
      case 'Spent':
        return loc.txStatusSpent;
      case 'Expired':
        return loc.txStatusExpired;
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isEarned = transaction.isEarned;
    final color = isEarned ? ColorsManager.successGreen : Colors.redAccent;
    final icon = isEarned
        ? Icons.arrow_upward_rounded
        : Icons.arrow_downward_rounded;

    final localizedSource = _localizeSource(transaction.source, loc);
    final localizedStatus = _localizeStatus(transaction.status, loc);
    final dateStr = DateFormat('MMM dd, yyyy').format(transaction.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorsManager.borderDim),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              // start = left in LTR, right in RTL — follows locale automatically
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizedSource,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.description,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '$dateStr · $localizedStatus',
                  style: const TextStyle(
                    color: ColorsManager.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${isEarned ? '+' : ''}${transaction.amount}',
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
