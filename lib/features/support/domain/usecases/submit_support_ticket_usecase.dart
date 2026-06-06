import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/support/domain/repositories/support_repository.dart';

class SubmitSupportTicketUseCase {
  final SupportRepository repository;

  SubmitSupportTicketUseCase(this.repository);

  ResultFuture<void> call({
    required String title,
    required String description,
    required int issueCategory,
  }) {
    return repository.submitTicket(
      title: title,
      description: description,
      issueCategory: issueCategory,
    );
  }
}
