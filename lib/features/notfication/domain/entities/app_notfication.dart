enum NotificationType {
  marketplace,
  gamification,
  boarding,
}

class AppNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String? titleAr;
  final String body;
  final String? messageAr;
  final DateTime receivedAt;
  final bool isRead;
  final Map<String, dynamic> payload;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    this.titleAr,
    required this.body,
    this.messageAr,
    required this.receivedAt,
    required this.isRead,
    required this.payload,
  });

  AppNotification copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? titleAr,
    String? body,
    String? messageAr,
    DateTime? receivedAt,
    bool? isRead,
    Map<String, dynamic>? payload,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      titleAr: titleAr ?? this.titleAr,
      body: body ?? this.body,
      messageAr: messageAr ?? this.messageAr,
      receivedAt: receivedAt ?? this.receivedAt,
      isRead: isRead ?? this.isRead,
      payload: payload ?? this.payload,
    );
  }
}