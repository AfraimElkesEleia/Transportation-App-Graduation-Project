import 'package:dio/dio.dart';
import 'package:transportation_app/core/constants/api_constants.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/data/model/indirect_trip_model.dart';
import 'package:transportation_app/features/search/data/model/trip_result_model.dart';

abstract class SearchRemoteDatasource {
  Future<List<TripResultModel>>   searchTrips(SearchParams params);
  Future<List<IndirectTripModel>> searchIndirectTrips(SearchParams params);
}

class SearchRemoteDatasourceImpl implements SearchRemoteDatasource {
  final Dio dio;
  SearchRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<TripResultModel>> searchTrips(SearchParams params) async {
    try {
      final res  = await dio.get(
        ApiConstants.search,
        queryParameters: params.toQueryParams(),
      );
      final body = res.data as Map<String, dynamic>;
      print('🔍 [Search] raw response: ${body['data']}');
      if (body['success'] != true) {
        throw ServerException(message: body['message'] ?? 'Search failed');
      }
      final data = body['data'] as List<dynamic>? ?? [];
      return data
          .map((t) => TripResultModel.fromJson(t as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  @override
  Future<List<IndirectTripModel>> searchIndirectTrips(
      SearchParams params) async {
    try {
      final res = await dio.get(
        ApiConstants.searchIndirect,
        queryParameters: params.toQueryParams(),
      );
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
            message: body['message'] ?? 'Indirect search failed');
      }
      final data = body['data'] as List<dynamic>? ?? [];
      return data
          .map((t) => IndirectTripModel.fromJson(t as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  Never _handleDio(DioException e) {
    if (e.type == DioExceptionType.connectionError  ||
        e.type == DioExceptionType.receiveTimeout   ||
        e.type == DioExceptionType.connectionTimeout) {
      throw NetworkException();
    }
    if (e.response?.statusCode == 400) {
      final body   = e.response?.data as Map<String, dynamic>?;
      final errors = (body?['errors'] as List<dynamic>?)
              ?.map((e) => e.toString()).toList() ?? [];
      throw ServerException(
        message:    body?['message'] ?? 'Invalid search parameters',
        errors:     errors,
        statusCode: 400,
      );
    }
    final body = e.response?.data as Map<String, dynamic>?;
    throw ServerException(
      message:    body?['message'] ?? 'Server error',
      statusCode: e.response?.statusCode,
    );
  }
}