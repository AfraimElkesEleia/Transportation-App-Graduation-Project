import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/notfication/domain/repositories/notfication_repository.dart';

class MarkAllNotificationsReadUseCase {
  final NotificationRepository repository;

  MarkAllNotificationsReadUseCase(this.repository);

  ResultFuture<void> call() => repository.markAllRead();
}
