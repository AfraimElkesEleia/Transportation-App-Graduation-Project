import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/features/support/domain/usecases/submit_support_ticket_usecase.dart';

// ── States ─────────────────────────────────────────────────────────────────

abstract class SupportState {}

class SupportInitial extends SupportState {}

class SupportLoading extends SupportState {}

class SupportSuccess extends SupportState {}

class SupportError extends SupportState {
  final String message;
  SupportError(this.message);
}

// ── Cubit ──────────────────────────────────────────────────────────────────

class SupportCubit extends Cubit<SupportState> {
  final SubmitSupportTicketUseCase submitSupportTicketUseCase;

  SupportCubit(this.submitSupportTicketUseCase) : super(SupportInitial());

  Future<void> submitTicket({
    required String title,
    required String description,
    required int issueCategory,
  }) async {
    emit(SupportLoading());
    final result = await submitSupportTicketUseCase(
      title: title,
      description: description,
      issueCategory: issueCategory,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(SupportError(failure.message)),
      (_) => emit(SupportSuccess()),
    );
  }
}
