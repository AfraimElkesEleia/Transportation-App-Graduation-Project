import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/notfication/presentation/cubit/notfication_state.dart';

/// Horizontal scrollable filter chips: All | Unread (with badge) | Marketplace.
class NotificationFilterBar extends StatelessWidget {
  final NotificationFilter active;
  final int unreadCount;
  final ValueChanged<NotificationFilter> onChanged;

  const NotificationFilterBar({
    super.key,
    required this.active,
    required this.unreadCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _Chip(
            label: loc.filterUnread,
            badge: unreadCount > 0 ? unreadCount : null,
            isActive: active == NotificationFilter.unread,
            onTap: () => onChanged(NotificationFilter.unread),
          ),
          const SizedBox(width: 8),
          _Chip(
            label: loc.filterMarketplace,
            isActive: active == NotificationFilter.marketplace,
            onTap: () => onChanged(NotificationFilter.marketplace),
          ),
          const SizedBox(width: 8),
          _Chip(
            label: loc.filterAll,
            isActive: active == NotificationFilter.all,
            onTap: () => onChanged(NotificationFilter.all),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final int? badge;
  final bool isActive;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = ColorsManager.accentCyan;
    final bg = isActive ? activeColor.withValues(alpha: 0.15) : ColorsManager.surfaceMid;
    final border = isActive ? activeColor.withValues(alpha: 0.5) : ColorsManager.borderSubtle;
    final textColor = isActive ? activeColor : ColorsManager.textMuted;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: ColorsManager.accentCyan,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge! > 99 ? '99+' : '$badge',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
