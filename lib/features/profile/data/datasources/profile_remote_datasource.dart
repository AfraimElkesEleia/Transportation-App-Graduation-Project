import 'package:dio/dio.dart';
import 'package:transportation_app/core/constants/api_constants.dart';
import 'package:transportation_app/core/error/exceptions.dart';

abstract class ProfileRemoteDatasource {
  Future<void> revokeToken({required String refreshToken});
}

class ProfileRemoteDataSourceImp implements ProfileRemoteDatasource {
  final Dio dio;

  ProfileRemoteDataSourceImp({required this.dio});
  @override
  Future<void> revokeToken({required String refreshToken}) async {
    try {
      final res = await dio.post(
        ApiConstants.revoke,
        data: {"refreshToken": refreshToken},
      );
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(message: body['message'] ?? 'Logout failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401)
        return;

      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout) {
        throw NetworkException();
      }
      final body = e.response?.data as Map<String, dynamic>?;
      throw ServerException(message: body?['message'] ?? 'Logout failed');
    }
  }
}
