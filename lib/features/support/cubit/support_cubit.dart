import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:transportation_app/core/constants/api_constants.dart';

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
  final Dio _dio;

  SupportCubit(this._dio) : super(SupportInitial());

  Future<void> submitTicket({
    required String title,
    required String description,
    required int issueCategory,
  }) async {
    emit(SupportLoading());
    try {
      final res = await _dio.post(
        ApiConstants.supportTickets,
        data: {
          'title': title,
          'description': description,
          'issueCategory': issueCategory,
        },
      );
      if (isClosed) return;
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        final errors =
            (body['errors'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .join('\n') ??
            '';
        emit(SupportError(errors.isNotEmpty
            ? errors
            : body['message'] ?? 'Failed to submit ticket'));
        return;
      }
      emit(SupportSuccess());
    } on DioException catch (e) {
      if (isClosed) return;
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout) {
        emit(SupportError('No internet connection. Please try again.'));
        return;
      }
      if (e.response?.statusCode == 401) {
        emit(SupportError('Session expired. Please log in again.'));
        return;
      }
      final body = e.response?.data as Map<String, dynamic>?;
      final msg = body?['message'] ?? 'Server error. Please try again.';
      emit(SupportError(msg));
    } catch (_) {
      if (isClosed) return;
      emit(SupportError('An unexpected error occurred.'));
    }
  }
}
