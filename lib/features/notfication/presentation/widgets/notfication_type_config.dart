import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/notfication/domain/entities/app_notfication.dart';

/// Maps [NotificationType] to display configuration.
///
/// [hasActions] always returns `false` — the SignalR backend does not send
/// a sub-type, so Accept / Decline buttons are never rendered.
abstract class NotificationTypeConfig {
  /// Returns `false` for all types (no sub-type available from backend).
  static bool hasActions(NotificationType type) => false;

  static IconData getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.marketplace:
        return Icons.local_offer_rounded;
      case NotificationType.gamification:
        return Icons.emoji_events_rounded;
      case NotificationType.boarding:
        return Icons.directions_bus_rounded;
      case NotificationType.refund:
        return Icons.account_balance_wallet_rounded;
      case NotificationType.general:
        return Icons.notifications_rounded;
    }
  }

  static Color getColor(NotificationType type) {
    switch (type) {
      case NotificationType.marketplace:
        return ColorsManager.accentCyan;
      case NotificationType.gamification:
        return ColorsManager.successGreen;
      case NotificationType.boarding:
        return ColorsManager.brightBlue;
      case NotificationType.refund:
        return ColorsManager.error;
      case NotificationType.general:
        return ColorsManager.textMuted;
    }
  }

  static String getLabel(NotificationType type) {
    switch (type) {
      case NotificationType.marketplace:
        return 'Marketplace';
      case NotificationType.gamification:
        return 'Gamification';
      case NotificationType.boarding:
        return 'Boarding';
      case NotificationType.refund:
        return 'Refunds';
      case NotificationType.general:
        return 'General';
    }
  }
}
