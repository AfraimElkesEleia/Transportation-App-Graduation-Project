// lib/features/search/data/datasources/search_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:transportation_app/core/constants/api_constants.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/data/model/indirect_trip_model.dart';
import 'package:transportation_app/features/search/data/model/page_result_model.dart';
import 'package:transportation_app/features/search/data/model/trip_result_model.dart';

abstract class SearchRemoteDatasource {
  Future<PageResultModel<TripResultModel>> searchTrips({
    required SearchParams params,
  });

  Future<PageResultModel<IndirectTripModel>> searchIndirectTrips({
    required SearchParams params,
  });
}

class SearchRemoteDatasourceImpl implements SearchRemoteDatasource {
  final Dio dio;
  SearchRemoteDatasourceImpl({required this.dio});

  @override
  Future<PageResultModel<TripResultModel>> searchTrips({
    required SearchParams params,
  }) async {
    try {
      final queryParams = params.toQueryParams();
      if (kDebugMode) {
        debugPrint(
          '[SearchTrips] GET ${ApiConstants.search} query=$queryParams',
        );
      }
      final res = await dio.get(
        ApiConstants.search,
        queryParameters: queryParams,
      );

      final body = res.data as Map<String, dynamic>;

      if (body['success'] != true) {
        throw ServerException(message: body['message'] ?? 'Search failed');
      }

      final dataObj = body['data'] as Map<String, dynamic>?;
      if (dataObj == null) {
        throw ServerException(message: 'Invalid response format');
      }

      final items = (dataObj['items'] as List<dynamic>? ?? [])
          .map((t) => TripResultModel.fromJson(t as Map<String, dynamic>))
          .toList();

      final page = PageResultModel<TripResultModel>(
        items: items,
        totalCount: dataObj['totalCount'] as int? ?? 0,
        totalPages: dataObj['totalPages'] as int? ?? 0,
        currentPage: dataObj['currentPage'] as int? ?? 1,
        pageSize: dataObj['pageSize'] as int? ?? 10,
      );
      if (kDebugMode) {
        debugPrint(
          '[SearchTrips] page=${page.currentPage}/${page.totalPages} '
          'totalCount=${page.totalCount} pageSize=${page.pageSize} '
          'items=${page.items.length}',
        );
      }
      return page;
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  @override
  Future<PageResultModel<IndirectTripModel>> searchIndirectTrips({
    required SearchParams params,
  }) async {
    try {
      final queryParams = params.toQueryParams();

      final res = await dio.get(
        ApiConstants.searchIndirect, // or ApiConstants.tripsSearchIndirect
        queryParameters: queryParams,
      );

      final body = res.data as Map<String, dynamic>;

      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] ?? 'Indirect search failed',
        );
      }

      // ✅ Parse paginated indirect response
      final dataObj = body['data'] as Map<String, dynamic>?;
      if (dataObj == null) {
        throw ServerException(message: 'Invalid response format');
      }

      final items = (dataObj['items'] as List<dynamic>? ?? [])
          .map((t) => IndirectTripModel.fromJson(t as Map<String, dynamic>))
          .toList();

      return PageResultModel<IndirectTripModel>(
        items: items,
        totalCount: dataObj['totalCount'] as int? ?? 0,
        totalPages: dataObj['totalPages'] as int? ?? 0,
        currentPage: dataObj['currentPage'] as int? ?? 1,
        pageSize: dataObj['pageSize'] as int? ?? 10,
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
    if (e.response?.statusCode == 400) {
      final body = e.response?.data as Map<String, dynamic>?;
      final errors =
          (body?['errors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      throw ServerException(
        message: body?['message'] ?? 'Invalid search parameters',
        errors: errors,
        statusCode: 400,
      );
    }
    final body = e.response?.data as Map<String, dynamic>?;
    throw ServerException(
      message: body?['message'] ?? 'Server error',
      statusCode: e.response?.statusCode,
    );
  }
}
