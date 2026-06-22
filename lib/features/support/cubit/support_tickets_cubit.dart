import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/features/support/domain/usecases/get_support_tickets_usecase.dart';
import 'package:transportation_app/features/support/domain/entities/support_ticket_entity.dart';

abstract class SupportTicketsState {}

class SupportTicketsInitial extends SupportTicketsState {}

class SupportTicketsLoading extends SupportTicketsState {}

class SupportTicketsLoaded extends SupportTicketsState {
  final List<SupportTicketEntity> tickets;

  SupportTicketsLoaded(this.tickets);
}

class SupportTicketsError extends SupportTicketsState {
  final String message;

  SupportTicketsError(this.message);
}

class SupportTicketsCubit extends Cubit<SupportTicketsState> {
  final GetSupportTicketsUseCase getSupportTicketsUseCase;

  SupportTicketsCubit(this.getSupportTicketsUseCase)
    : super(SupportTicketsInitial());

  Future<void> loadTickets() async {
    emit(SupportTicketsLoading());
    final result = await getSupportTicketsUseCase();
    if (isClosed) return;
    result.fold(
      (failure) => emit(SupportTicketsError(failure.message)),
      (tickets) => emit(SupportTicketsLoaded(tickets)),
    );
  }
}
