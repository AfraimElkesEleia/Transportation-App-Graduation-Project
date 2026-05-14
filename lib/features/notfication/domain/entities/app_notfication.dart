enum NotificationType {
  offerReceived,
  offerAccepted,
  offerRejected,
  counterOfferReceived,
  ticketSold,
}

class AppNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime receivedAt;
  final bool isRead;
  final Map<String, dynamic> payload;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.receivedAt,
    required this.isRead,
    required this.payload,
  });

  AppNotification copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? body,
    DateTime? receivedAt,
    bool? isRead,
    Map<String, dynamic>? payload,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      receivedAt: receivedAt ?? this.receivedAt,
      isRead: isRead ?? this.isRead,
      payload: payload ?? this.payload,
    );
  }

  String? get offerId => payload['offerId'] as String?;
  String? get listingId => payload['listingId'] as String?;
  String? get offeredPrice => payload['offeredPrice'] as String?;
  String? get route => payload['route'] as String?;
}