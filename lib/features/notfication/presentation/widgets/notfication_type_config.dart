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
      case NotificationType.offerReceived:
        return Icons.local_offer_rounded;
      case NotificationType.offerAccepted:
        return Icons.check_circle_rounded;
      case NotificationType.offerRejected:
        return Icons.cancel_rounded;
      case NotificationType.counterOfferReceived:
        return Icons.compare_arrows_rounded;
      case NotificationType.ticketSold:
        return Icons.confirmation_num_rounded;
    }
  }

  static Color getColor(NotificationType type) {
    switch (type) {
      case NotificationType.offerReceived:
        return ColorsManager.accentCyan;
      case NotificationType.offerAccepted:
        return ColorsManager.successGreen;
      case NotificationType.offerRejected:
        return const Color(0xFFFF5252);
      case NotificationType.counterOfferReceived:
        return ColorsManager.turquoise;
      case NotificationType.ticketSold:
        return ColorsManager.brightBlue;
    }
  }

  static String getLabel(NotificationType type) {
    switch (type) {
      case NotificationType.offerReceived:
        return 'Offer Received';
      case NotificationType.offerAccepted:
        return 'Offer Accepted';
      case NotificationType.offerRejected:
        return 'Offer Rejected';
      case NotificationType.counterOfferReceived:
        return 'Counter Offer';
      case NotificationType.ticketSold:
        return 'Ticket Sold';
    }
  }
}
