import 'package:dio/dio.dart';
import 'package:transportation_app/core/constants/api_constants.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/features/signup/data/models/auth_response.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String firstName,
    required String lastName,
    required String familyName,
    required int gender,
    required String dateOfBirth,
    required String countryCode,
    String? nationalIdNumber,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  Map<String, dynamic> _validateAndExtract(Response response) {
    final body = response.data as Map<String, dynamic>;
    if (body['success'] != true) {
      final errors =
          (body['errors'] as List<dynamic>?)
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

  @override
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String firstName,
    required String lastName,
    required String familyName,
    required int gender,
    required String dateOfBirth,
    required String countryCode,
    String? nationalIdNumber,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.register,
        data: {
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'phoneNumber': phoneNumber,
          'firstName': firstName,
          'lastName': lastName,
          'familyName': familyName,
          'gender': gender,
          'dateOfBirth': dateOfBirth,
          'countryCode': countryCode,
          if (nationalIdNumber != null) 'nationalIdNumber': nationalIdNumber,
        },
      );
      final data = _validateAndExtract(response);
      return AuthResponseModel.fromJson(data);
    } on DioException catch (e) {
      print('🔴 [DataSource] DioException type: ${e.type}');
      print('🔴 [DataSource] statusCode: ${e.response?.statusCode}');
      print('🔴 [DataSource] body: ${e.response?.data}');
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout) {
        throw NetworkException();
      }

      final body = e.response?.data as Map<String, dynamic>?;
      final errors =
          (body?['errors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];

      throw ServerException(
        message: body?['message'] ?? 'Server error',
        errors: errors,
        statusCode: e.response?.statusCode,
      );
    }
  }
}
