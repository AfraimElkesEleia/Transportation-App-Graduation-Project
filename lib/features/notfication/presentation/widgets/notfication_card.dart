import 'package:flutter/material.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/notfication/domain/entities/app_notfication.dart';
import 'package:transportation_app/features/notfication/presentation/widgets/notfication_type_config.dart';

/// Dismissible swipe-left card for a single notification.
///
/// [onAccept] and [onDecline] are always `null` because the backend does not
/// send a sub-type ([NotificationTypeConfig.hasActions] returns `false`).
class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDismiss,
    this.onAccept,
    this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      background: _DismissBackground(),
      onDismissed: (_) => onDismiss(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: notification.isRead
                ? ColorsManager.surfaceMid
                : ColorsManager.cardUnread,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead
                  ? ColorsManager.borderSubtle
                  : ColorsManager.cardBorderUnread,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Type icon ────────────────────────────────────────────
                _TypeIcon(type: notification.type),
                const SizedBox(width: 12),

                // ── Title + body ─────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                // Fallback to English when Arabic is null or empty
                                final arTitle = notification.titleAr;
                                final displayTitle =
                                    context.isArabic &&
                                        arTitle != null &&
                                        arTitle.isNotEmpty
                                    ? arTitle
                                    : notification.title;
                                return Text(
                                  displayTitle,
                                  style: TextStyle(
                                    color: notification.isRead
                                        ? ColorsManager.textMuted
                                        : Colors.white,
                                    fontSize: 14,
                                    fontWeight: notification.isRead
                                        ? FontWeight.w500
                                        : FontWeight.w700,
                                  ),
                                );
                              },
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(left: 8),
                              decoration: const BoxDecoration(
                                color: ColorsManager.accentCyan,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Builder(
                        builder: (context) {
                          // Fallback to English when Arabic is null or empty
                          final arBody = notification.messageAr;
                          final displayBody =
                              context.isArabic &&
                                  arBody != null &&
                                  arBody.isNotEmpty
                              ? arBody
                              : notification.body;
                          return Text(
                            displayBody,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: ColorsManager.textMuted,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _relativeTime(notification.receivedAt),
                        style: const TextStyle(
                          color: ColorsManager.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${dt.day} ${_month(dt.month)} ${dt.year}';
  }

  String _month(int m) => const [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][m];
}

// ── Type icon bubble ──────────────────────────────────────────────────────────

class _TypeIcon extends StatelessWidget {
  final NotificationType type;
  const _TypeIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    final color = NotificationTypeConfig.getColor(type);
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Icon(NotificationTypeConfig.getIcon(type), color: color, size: 20),
    );
  }
}

// ── Dismiss background ────────────────────────────────────────────────────────

class _DismissBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFF5252).withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF5252).withValues(alpha: 0.3)),
      ),
      child: Builder(
        builder: (context) {
          final loc = AppLocalizations.of(context)!;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.delete_rounded,
                color: Color(0xFFFF5252),
                size: 22,
              ),
              const SizedBox(height: 4),
              Text(
                loc.dismiss,
                style: const TextStyle(color: Color(0xFFFF5252), fontSize: 11),
              ),
            ],
          );
        },
      ),
    );
  }
}
