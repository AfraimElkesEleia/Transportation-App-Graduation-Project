import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/notfication/domain/repositories/notfication_repository.dart';

class MarkNotificationReadUseCase {
  final NotificationRepository repository;

  MarkNotificationReadUseCase(this.repository);

  ResultFuture<void> call(String id) => repository.markRead(id);
}
