import 'package:dio/dio.dart';
import 'package:transportation_app/core/constants/api_constants.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/features/home/data/models/station_model.dart';

abstract class StationsRemoteDatasource {
  Future<List<StationGroupModel>> getStations();
}

class StationsRemoteDatasourceImpl implements StationsRemoteDatasource {
  final Dio dio;
  StationsRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<StationGroupModel>> getStations() async {
    try {
      final res  = await dio.get(ApiConstants.stations);
      final body = res.data as Map<String, dynamic>;

      if (body['success'] != true) {
        throw ServerException(message: body['message'] ?? 'Failed to load stations');
      }

      final data = body['data'] as List<dynamic>? ?? [];
      return data
          .map((g) => StationGroupModel.fromJson(g as Map<String, dynamic>))
          .toList();

    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  Never _handleDio(DioException e) {
    if (e.type == DioExceptionType.connectionError   ||
        e.type == DioExceptionType.receiveTimeout    ||
        e.type == DioExceptionType.connectionTimeout) {
      throw NetworkException();
    }
    final body   = e.response?.data as Map<String, dynamic>?;
    final errors = (body?['errors'] as List<dynamic>?)
            ?.map((e) => e.toString()).toList() ?? [];
    throw ServerException(
      message:    body?['message'] ?? 'Server error',
      errors:     errors,
      statusCode: e.response?.statusCode,
    );
  }
}