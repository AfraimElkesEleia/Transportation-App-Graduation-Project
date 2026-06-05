import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/constants/api_constants.dart';
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
  final Dio _dio;

  SupportTicketsCubit(this._dio) : super(SupportTicketsInitial());

  Future<void> loadTickets() async {
    emit(SupportTicketsLoading());
    try {
      final res = await _dio.get(ApiConstants.supportTickets);
      if (isClosed) return;

      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        final errors =
            (body['errors'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .join('\n') ??
            '';
        emit(
          SupportTicketsError(
            errors.isNotEmpty
                ? errors
                : body['message'] ?? 'Failed to load support tickets',
          ),
        );
        return;
      }

      final data = body['data'] as List<dynamic>? ?? [];
      final tickets = data
          .map(
            (item) =>
                SupportTicketEntity.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      emit(SupportTicketsLoaded(tickets));
    } on DioException catch (e) {
      if (isClosed) return;
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout) {
        emit(SupportTicketsError('No internet connection. Please try again.'));
        return;
      }
      if (e.response?.statusCode == 401) {
        emit(SupportTicketsError('Session expired. Please log in again.'));
        return;
      }
      final body = e.response?.data as Map<String, dynamic>?;
      emit(
        SupportTicketsError(
          body?['message'] ?? 'Server error. Please try again.',
        ),
      );
    } catch (_) {
      if (isClosed) return;
      emit(SupportTicketsError('An unexpected error occurred.'));
    }
  }
}
