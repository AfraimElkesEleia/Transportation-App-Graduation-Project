import 'package:dio/dio.dart';
import 'package:transportation_app/core/constants/api_constants.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/signup/data/models/auth_response.dart';

abstract class LoginRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
    String? deviceInfo,
  });
  Future<void> forgotPassword({required String email});
  Future<void> resetPassword({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  });
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
  Future<AuthResponseModel> refreshToken({required String refreshToken});
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final Dio dio;
  LoginRemoteDataSourceImpl({required this.dio});

  // ── Unwraps the standard ApiResponse<T> wrapper ─────────────────────────
  DataMap _unwrap(Response response) {
    final body = response.data as Map<String, dynamic>;
    if (body['success'] != true) {
      final errors = (body['errors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      throw ServerException(
        message: body['message'] ?? 'Request failed',
        errors: errors,
      );
    }
    return body['data'] as Map<String, dynamic>? ?? {};
  }

  Never _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionTimeout) {
      throw NetworkException();
    }
    if (e.type == DioExceptionType.badResponse) {
      final statusCode = e.response?.statusCode;
      final body = e.response?.data as Map<String, dynamic>?;
      final message = body?['message'] as String?;
      final errors = (body?['errors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      if (statusCode == 401) {
        throw UnauthorizedException(
          message: message ?? 'Unauthorized. Please login again.',
        );
      }
      // 400 — validation or business logic failure
      // 404 — resource not found
      // 409 — conflict (e.g. email already registered)
      // 500 — server error
      throw ServerException(
        message: message ?? 'Server error ($statusCode)',
        errors: errors,
        statusCode: statusCode,
      );
    }
    if (e.type == DioExceptionType.cancel) {
      throw ServerException(message: 'Request was cancelled.');
    }
    throw ServerException(message: e.message ?? 'Unexpected error occurred.');
  }

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
    String? deviceInfo,
  }) async {
    try {
      final res = await dio.post(ApiConstants.login, data: {
        'email':    email,
        'password': password,
        if (deviceInfo != null) 'deviceInfo': deviceInfo,
      });
      return AuthResponseModel.fromJson(_unwrap(res));
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await dio.post(ApiConstants.forgotPassword, data: {'email': email});
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final res = await dio.post(ApiConstants.resetPassword, data: {
        'email':           email,
        'token':           token,
        'newPassword':     newPassword,
        'confirmPassword': confirmPassword,
      });
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        final errors = (body['errors'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [];
        throw ServerException(
          message: body['message'] ?? 'Password reset failed',
          errors: errors,
        );
      }
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final res = await dio.post(ApiConstants.changePassword, data: {
        'currentPassword': currentPassword,
        'newPassword':     newPassword,
        'confirmPassword': confirmPassword,
      });
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        final errors = (body['errors'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [];
        throw ServerException(
          message: body['message'] ?? 'Password change failed',
          errors: errors,
        );
      }
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<AuthResponseModel> refreshToken({required String refreshToken}) async {
    try {
      final res = await dio.post(
        ApiConstants.refresh,
        data: {'refreshToken': refreshToken},
      );
      return AuthResponseModel.fromJson(_unwrap(res));
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }
}