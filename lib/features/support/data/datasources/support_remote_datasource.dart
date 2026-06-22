import 'package:dio/dio.dart';
import 'package:transportation_app/core/constants/api_constants.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/features/support/data/models/support_ticket_model.dart';

abstract class SupportRemoteDatasource {
  Future<void> submitTicket({
    required String title,
    required String description,
    required int issueCategory,
  });

  Future<List<SupportTicketModel>> getTickets();
}

class SupportRemoteDatasourceImpl implements SupportRemoteDatasource {
  final Dio dio;

  SupportRemoteDatasourceImpl({required this.dio});

  @override
  Future<void> submitTicket({
    required String title,
    required String description,
    required int issueCategory,
  }) async {
    try {
      final res = await dio.post(
        ApiConstants.supportTickets,
        data: {
          'title': title,
          'description': description,
          'issueCategory': issueCategory,
        },
      );
      _ensureSuccess(res.data as Map<String, dynamic>, 'Failed to submit ticket');
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  @override
  Future<List<SupportTicketModel>> getTickets() async {
    try {
      final res = await dio.get(ApiConstants.supportTickets);
      final body = res.data as Map<String, dynamic>;
      _ensureSuccess(body, 'Failed to load support tickets');
      final data = body['data'] as List<dynamic>? ?? [];
      return data
          .map((item) => SupportTicketModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  void _ensureSuccess(Map<String, dynamic> body, String fallback) {
    if (body['success'] == true) {
      return;
    }
    final errors =
        (body['errors'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
            [];
    throw ServerException(
      message: errors.isNotEmpty ? errors.join('\n') : body['message'] ?? fallback,
      errors: errors,
    );
  }

  Never _handleDio(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionTimeout) {
      throw NetworkException();
    }
    if (e.response?.statusCode == 401) {
      throw UnauthorizedException(message: 'Session expired. Please log in again.');
    }
    final body = e.response?.data as Map<String, dynamic>?;
    throw ServerException(
      message: body?['message'] ?? 'Server error. Please try again.',
      statusCode: e.response?.statusCode,
    );
  }
}
