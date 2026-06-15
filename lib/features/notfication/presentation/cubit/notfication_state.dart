import 'package:equatable/equatable.dart';
import 'package:transportation_app/features/notfication/domain/entities/app_notfication.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationLoaded extends NotificationState {
  final List<AppNotification> notifications;
  final NotificationFilter activeFilter;
  final String? deleteErrorMessage;
  final bool deleteSucceeded;

  const NotificationLoaded({
    required this.notifications,
    this.activeFilter = NotificationFilter.all,
    this.deleteErrorMessage,
    this.deleteSucceeded = false,
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  List<AppNotification> get filtered {
    switch (activeFilter) {
      case NotificationFilter.all:
        return notifications;
      case NotificationFilter.marketplace:
        return notifications
            .where((n) => n.type == NotificationType.marketplace)
            .toList();
      case NotificationFilter.boarding:
        return notifications
            .where((n) => n.type == NotificationType.boarding)
            .toList();
      case NotificationFilter.gamification:
        return notifications
            .where((n) => n.type == NotificationType.gamification)
            .toList();
      case NotificationFilter.refund:
        return notifications
            .where((n) => n.type == NotificationType.refund)
            .toList();
      case NotificationFilter.unread:
        return notifications.where((n) => !n.isRead).toList();
    }
  }

  /// Groups filtered notifications by date section (Today / Yesterday / older label)
  Map<String, List<AppNotification>> get grouped {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final Map<String, List<AppNotification>> groups = {};

    for (final notif in filtered) {
      final d = DateTime(
        notif.receivedAt.year,
        notif.receivedAt.month,
        notif.receivedAt.day,
      );
      final String key;
      if (d == today) {
        key = 'Today';
      } else if (d == yesterday) {
        key = 'Yesterday';
      } else {
        key =
            '${notif.receivedAt.day} ${_month(notif.receivedAt.month)} ${notif.receivedAt.year}';
      }
      groups.putIfAbsent(key, () => []).add(notif);
    }

    return groups;
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

  @override
  List<Object?> get props => [
    notifications,
    activeFilter,
    deleteErrorMessage,
    deleteSucceeded,
  ];

  NotificationLoaded copyWith({
    List<AppNotification>? notifications,
    NotificationFilter? activeFilter,
    String? deleteErrorMessage,
    bool clearDeleteError = false,
    bool? deleteSucceeded,
  }) {
    return NotificationLoaded(
      notifications: notifications ?? this.notifications,
      activeFilter: activeFilter ?? this.activeFilter,
      deleteErrorMessage: clearDeleteError
          ? null
          : deleteErrorMessage ?? this.deleteErrorMessage,
      deleteSucceeded: deleteSucceeded ?? false,
    );
  }
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}

enum NotificationFilter {
  all,
  marketplace,
  boarding,
  gamification,
  refund,
  unread,
}
