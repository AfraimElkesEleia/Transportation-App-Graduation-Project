import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';

class LoyaltyPointsCard extends StatefulWidget {
  final ProfileEntity? profile;
  
  const LoyaltyPointsCard({super.key, this.profile});

  @override
  State<LoyaltyPointsCard> createState() => _LoyaltyPointsCardState();
}

class _LoyaltyPointsCardState extends State<LoyaltyPointsCard> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final points = widget.profile?.loyaltyPointsBalance;
    final expiring = widget.profile?.expiringPointsAmount;
    final expiryDate = widget.profile?.nextExpiryDate;
    String expiringText = l10n.noExpiringPoints;
    
    if (expiring != null && expiring > 0 && expiryDate != null) {
      final expiry = DateTime.parse(expiryDate).toLocal();
      final diff = expiry.difference(DateTime.now());
      if (diff.inDays <= 0) {
        expiringText = l10n.ptsExpired(expiring.toString());
      } else if (diff.inDays == 1) {
        expiringText = l10n.ptsExpireTomorrow(expiring.toString());
      } else if (diff.inDays < 30) {
        expiringText = l10n.ptsExpireInDays(expiring.toString(), diff.inDays.toString());
      } else {
        final months = diff.inDays ~/ 30;
        final days = diff.inDays % 30;
        String mStr = months == 1 ? l10n.oneMonth : l10n.monthsPlural(months.toString());
        String dStr = days == 1 ? l10n.oneDay : l10n.daysPlural(days.toString());
        expiringText = days > 0
            ? l10n.ptsExpireInMonthsDays(expiring.toString(), mStr, dStr)
            : l10n.ptsExpireInMonths(expiring.toString(), mStr);
      }
    }
    
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.loyaltyHub, arguments: {
          'pointsBalance': points ?? 0,
          'expiringAmount': expiring ?? 0,
          'nextExpiryDate': expiryDate,
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D2B5E), Color(0xFF1A4A8A)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFFD700),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.loyaltyPoints,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                points?.toString() ?? '--',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  l10n.pts,
                  style: const TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            expiringText,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.pointsPending,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    ));
  }
}
