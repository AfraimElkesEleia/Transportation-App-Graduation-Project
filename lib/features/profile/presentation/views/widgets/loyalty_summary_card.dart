import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';

class LoyaltySummaryCard extends StatelessWidget {
  final int pointsBalance;
  final int expiringAmount;
  final String? nextExpiryDate;

  const LoyaltySummaryCard({
    super.key,
    required this.pointsBalance,
    required this.expiringAmount,
    this.nextExpiryDate,
  });

  String _expiryLabel(AppLocalizations loc) {
    if (nextExpiryDate == null || expiringAmount <= 0) return '';
    final expiry = DateTime.parse(nextExpiryDate!).toLocal();
    final diff = expiry.difference(DateTime.now());
    final n = '$expiringAmount';

    if (diff.inDays <= 0) return loc.ptsExpired(n);
    if (diff.inDays == 1) return loc.ptsExpireTomorrow(n);

    if (diff.inDays < 30) {
      final d = diff.inDays == 1 ? loc.oneDay : loc.daysPlural('${diff.inDays}');
      return loc.ptsExpireInDays(n, d);
    }

    final months = diff.inDays ~/ 30;
    final days = diff.inDays % 30;
    final mStr = months == 1 ? loc.oneMonth : loc.monthsPlural('$months');

    if (days > 0) {
      final dStr = days == 1 ? loc.oneDay : loc.daysPlural('$days');
      return loc.ptsExpireInMonthsDays(n, mStr, dStr);
    }
    return loc.ptsExpireInMonths(n, mStr);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isAr = Directionality.of(context) == TextDirection.rtl;
    final expiryText = _expiryLabel(loc);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceMid,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsManager.borderDim),
      ),
      child: Column(
        crossAxisAlignment:
            isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            loc.availableBalance,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment:
                isAr ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.stars_rounded,
                color: Color(0xFFFFD700),
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                '$pointsBalance ${loc.pts}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (expiryText.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      expiryText,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
