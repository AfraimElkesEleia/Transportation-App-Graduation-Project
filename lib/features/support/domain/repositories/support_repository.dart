import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/support/domain/entities/support_ticket_entity.dart';

abstract class SupportRepository {
  ResultFuture<void> submitTicket({
    required String title,
    required String description,
    required int issueCategory,
  });

  ResultFuture<List<SupportTicketEntity>> getTickets();
}
