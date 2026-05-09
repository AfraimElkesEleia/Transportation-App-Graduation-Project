import 'package:dio/dio.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/features/home/data/models/popular_route_model.dart';

abstract class PopularRoutesDatasource {
  Future<List<PopularRouteModel>> getPopularRoutes();
}

class PopularRoutesDatasourceImpl implements PopularRoutesDatasource {
  final Dio dio;

  PopularRoutesDatasourceImpl({required this.dio});

  @override
  Future<List<PopularRouteModel>> getPopularRoutes() async {
    try {
      final res = await dio.get('/trips/popular-routes');
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(message: body['message'] ?? 'Failed to load popular routes');
      }
      final data = body['data'] as List<dynamic>? ?? [];
      return data.map((json) => PopularRouteModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout) {
        throw NetworkException();
      }
      final body = e.response?.data as Map<String, dynamic>?;
      throw ServerException(message: body?['message'] ?? 'Server error');
    }
  }
}
