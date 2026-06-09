import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/notfication/domain/repositories/notfication_repository.dart';

class DeleteNotificationUseCase {
  final NotificationRepository repository;

  DeleteNotificationUseCase(this.repository);

  ResultFuture<void> call(String id) => repository.deleteNotification(id);
}
