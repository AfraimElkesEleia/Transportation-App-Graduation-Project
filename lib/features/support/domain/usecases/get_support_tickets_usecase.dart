import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/support/domain/entities/support_ticket_entity.dart';
import 'package:transportation_app/features/support/domain/repositories/support_repository.dart';

class GetSupportTicketsUseCase {
  final SupportRepository repository;

  GetSupportTicketsUseCase(this.repository);

  ResultFuture<List<SupportTicketEntity>> call() => repository.getTickets();
}
