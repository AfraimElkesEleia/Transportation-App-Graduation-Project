import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';

/// Centered empty-state illustration displayed when the notification list is empty.
/// The [filter] string matches [NotificationFilter.name].
class NotificationEmptyState extends StatelessWidget {
  final String filter;

  const NotificationEmptyState({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    final config = _config(context, filter);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: ColorsManager.surfaceMid,
                shape: BoxShape.circle,
                border: Border.all(
                  color: ColorsManager.borderSubtle,
                  width: 1.5,
                ),
              ),
              child: Icon(
                config.icon,
                size: 36,
                color: ColorsManager.textMuted,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              config.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              config.subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ColorsManager.textMuted,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _EmptyConfig _config(BuildContext context, String filter) {
    final loc = AppLocalizations.of(context)!;
    switch (filter) {
      case 'marketplace':
        return _EmptyConfig(
          icon: Icons.storefront_rounded,
          title: loc.emptyMarketplaceTitle,
          subtitle: loc.emptyMarketplaceSubtitle,
        );
      case 'unread':
        return _EmptyConfig(
          icon: Icons.mark_email_read_rounded,
          title: loc.emptyUnreadTitle,
          subtitle: loc.emptyUnreadSubtitle,
        );
      case 'boarding':
        return _EmptyConfig(
          icon: Icons.directions_bus_rounded,
          title: loc.emptyBoardingTitle,
          subtitle: loc.emptyBoardingSubtitle,
        );
      case 'gamification':
        return _EmptyConfig(
          icon: Icons.emoji_events_rounded,
          title: loc.emptyGamificationTitle,
          subtitle: loc.emptyGamificationSubtitle,
        );
      case 'refund':
        return _EmptyConfig(
          icon: Icons.account_balance_wallet_rounded,
          title: loc.emptyRefundTitle,
          subtitle: loc.emptyRefundSubtitle,
        );
      default:
        return _EmptyConfig(
          icon: Icons.notifications_off_rounded,
          title: loc.emptyNotificationsTitle,
          subtitle: loc.emptyNotificationsSubtitle,
        );
    }
  }
}

class _EmptyConfig {
  final IconData icon;
  final String title;
  final String subtitle;
  const _EmptyConfig({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
