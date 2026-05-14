import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';

/// Centered empty-state illustration displayed when the notification list is empty.
/// The [filter] string matches [NotificationFilter.name]: `'all'`, `'marketplace'`, `'unread'`.
class NotificationEmptyState extends StatelessWidget {
  final String filter;

  const NotificationEmptyState({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    final config = _config(filter);
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
                border: Border.all(color: ColorsManager.borderSubtle, width: 1.5),
              ),
              child: Icon(config.icon, size: 36, color: ColorsManager.textMuted),
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

  _EmptyConfig _config(String filter) {
    switch (filter) {
      case 'marketplace':
        return const _EmptyConfig(
          icon: Icons.storefront_rounded,
          title: 'No marketplace activity yet',
          subtitle: 'Offers and sales notifications will appear here.',
        );
      case 'unread':
        return const _EmptyConfig(
          icon: Icons.mark_email_read_rounded,
          title: "You're all caught up!",
          subtitle: 'No unread notifications at the moment.',
        );
      default:
        return const _EmptyConfig(
          icon: Icons.notifications_off_rounded,
          title: 'No notifications yet',
          subtitle: 'Important updates about your trips and marketplace activity will show here.',
        );
    }
  }
}

class _EmptyConfig {
  final IconData icon;
  final String title;
  final String subtitle;
  const _EmptyConfig({required this.icon, required this.title, required this.subtitle});
}
