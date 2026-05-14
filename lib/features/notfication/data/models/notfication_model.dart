import 'package:transportation_app/features/notfication/domain/entities/app_notfication.dart';

class NotficationModel {
  final int id;
  final bool isRead;
  final DateTime createdAt;
  final String title;
  final String message;
  final String type;
  const NotficationModel({
    required this.id,
    required this.isRead,
    required this.createdAt,
    required this.title,
    required this.message,
    required this.type,
  });

  factory NotficationModel.fromJson(Map<String, dynamic> json) {
    return NotficationModel(
      id: (json['id'] as num).toInt(),
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      type: json['type'] as String? ?? 'Marketplace',
    );
  }
  AppNotification toEntity() => AppNotification(
    id: id.toString(),
    type: _mapType(type),
    title: title,
    body: message,
    receivedAt: createdAt,
    isRead: isRead,
    payload: {'type': type},
  );
  NotificationType _mapType(String t) {
    switch (t) {
      case 'Marketplace':
        return NotificationType.offerReceived;
      default:
        return NotificationType.offerReceived;
    }
  }
}
