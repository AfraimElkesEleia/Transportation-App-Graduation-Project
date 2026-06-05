import 'package:flutter/material.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/notfication/domain/entities/app_notfication.dart';
import 'package:transportation_app/features/notfication/presentation/widgets/notfication_type_config.dart';

/// Card for a single notification.
///
/// [onAccept] and [onDecline] are always `null` because the backend does not
/// send a sub-type ([NotificationTypeConfig.hasActions] returns `false`).
class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onAccept,
    this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: notification.isRead ? null : onTap,
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
                      _relativeTime(context, notification.receivedAt),
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
    );
  }

  String _relativeTime(BuildContext context, DateTime dt) {
    final loc = AppLocalizations.of(context)!;
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return loc.justNow;
    if (diff.inMinutes < 60) return loc.minutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return loc.hoursAgo(diff.inHours);
    if (diff.inDays == 1) return loc.yesterdayLabel;
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
