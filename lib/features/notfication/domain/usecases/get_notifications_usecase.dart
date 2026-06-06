import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/notfication/domain/entities/app_notfication.dart';
import 'package:transportation_app/features/notfication/domain/repositories/notfication_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  ResultFuture<List<AppNotification>> call() => repository.getNotifications();
}
