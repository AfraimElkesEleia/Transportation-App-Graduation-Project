import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/notfication/domain/entities/app_notfication.dart';

abstract class NotificationRepository {
  ResultFuture<List<AppNotification>> getNotifications();
  ResultFuture<void> markRead(String id);
  ResultFuture<void> markAllRead();
}
