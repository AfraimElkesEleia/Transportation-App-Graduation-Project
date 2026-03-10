import 'package:dio/dio.dart';
import 'package:transportation_app/core/constants/api_constants.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/features/profile/data/models/profile_model.dart';

abstract class ProfileRemoteDatasource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile({
    required String firstName,
    required String lastName,
    required String familyName,
    required String email,
    required String phoneNumber,
  });
  Future<String> uploadProfilePicture({required String filePath});
  Future<void> revokeToken({required String refreshToken});
}

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final Dio dio;
  ProfileRemoteDatasourceImpl({required this.dio});
  @override
  Future<ProfileModel> getProfile() async {
    try {
      final res = await dio.get(ApiConstants.userMe);
      final body = res.data as Map<String, dynamic>;
      print('📦 [Profile] raw data: ${body['data']}');
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] ?? 'Failed to load profile',
        );
      }
      return ProfileModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

 @override
Future<ProfileModel> updateProfile({
  required String firstName,
  required String lastName,
  required String familyName,
  required String email,
  required String phoneNumber,
}) async {
  try {
    final res = await dio.put(
      ApiConstants.userMe,
      data: {
        'firstName':   firstName,
        'lastName':    lastName,
        'familyName':  familyName,
        'email':       email,
        'phoneNumber': phoneNumber,
      },
    );
    final body = res.data as Map<String, dynamic>;
    if (body['success'] != true) {
      final errors = (body['errors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ?? [];
      throw ServerException(
        message: body['message'] ?? 'Update failed',
        errors:  errors,
      );
    }
    return await getProfile();
  } on DioException catch (e) {
    _handleDio(e);
  }
}

  @override
  Future<String> uploadProfilePicture({required String filePath}) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });

      final res = await dio.post(
        ApiConstants.userProfilePicture,
        data: formData,
      );

      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(message: body['message'] ?? 'Upload failed');
      }

      final data = body['data'] as Map<String, dynamic>;
      return data['profilePictureUrl'] as String;
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  @override
  Future<void> revokeToken({required String refreshToken}) async {
    try {
      await dio.post(ApiConstants.revoke, data: {'refreshToken': refreshToken});
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401)
        return;
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
      throw UnauthorizedException(
        message: 'Session expired. Please login again.',
      );
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
