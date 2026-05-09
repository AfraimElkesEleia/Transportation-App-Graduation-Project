import 'package:dio/dio.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/core/models/paged_result.dart';
import 'package:transportation_app/features/profile/data/models/challenge_history_model.dart';
import 'package:transportation_app/features/profile/data/models/point_transaction_model.dart';

abstract class LoyaltyRemoteDatasource {
  Future<PagedResult<PointTransactionModel>> getPointHistory({
    int pageNumber = 1,
    int pageSize = 10,
  });

  Future<PagedResult<ChallengeHistoryModel>> getChallengeHistory({
    bool? isCompleted,
    int pageNumber = 1,
    int pageSize = 10,
  });
}

class LoyaltyRemoteDatasourceImpl implements LoyaltyRemoteDatasource {
  final Dio dio;

  LoyaltyRemoteDatasourceImpl({required this.dio});

  @override
  Future<PagedResult<PointTransactionModel>> getPointHistory({
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      final res = await dio.get(
        '/Loyalty/history',
        queryParameters: {'pageNumber': pageNumber, 'pageSize': pageSize},
      );
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(message: body['message'] ?? 'Failed to load point history');
      }
      final data = body['data'] as Map<String, dynamic>;
      final itemsList = data['items'] as List<dynamic>? ?? [];
      
      return PagedResult(
        items: itemsList.map((j) => PointTransactionModel.fromJson(j as Map<String, dynamic>)).toList(),
        totalCount: data['totalCount'] ?? 0,
        totalPages: data['totalPages'] ?? 1,
        currentPage: data['currentPage'] ?? 1,
        pageSize: data['pageSize'] ?? 10,
      );
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  @override
  Future<PagedResult<ChallengeHistoryModel>> getChallengeHistory({
    bool? isCompleted,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      };
      if (isCompleted != null) {
        queryParams['isCompleted'] = isCompleted;
      }

      final res = await dio.get(
        '/Loyalty/challenges',
        queryParameters: queryParams,
      );
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(message: body['message'] ?? 'Failed to load challenges');
      }
      final data = body['data'] as Map<String, dynamic>;
      final itemsList = data['items'] as List<dynamic>? ?? [];
      
      return PagedResult(
        items: itemsList.map((j) => ChallengeHistoryModel.fromJson(j as Map<String, dynamic>)).toList(),
        totalCount: data['totalCount'] ?? 0,
        totalPages: data['totalPages'] ?? 1,
        currentPage: data['currentPage'] ?? 1,
        pageSize: data['pageSize'] ?? 10,
      );
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  Never _handleDio(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionTimeout) {
      throw NetworkException();
    }
    if (e.response?.statusCode == 401) {
      throw UnauthorizedException(message: 'Please login to continue.');
    }
    final body = e.response?.data as Map<String, dynamic>?;
    throw ServerException(message: body?['message'] ?? 'Server error');
  }
}
