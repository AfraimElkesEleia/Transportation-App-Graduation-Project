import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:transportation_app/core/constants/api_constants.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/features/profile/data/models/profile_model.dart';
import 'package:transportation_app/features/profile/domain/entities/wallet_transaction_entity.dart';

abstract class ProfileRemoteDatasource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile({
    required String firstName,
    required String lastName,
    required String familyName,
    required String email,
    required String phoneNumber,
    int? idType,
    String? idNumber,
  });
  Future<String> uploadProfilePicture({required String filePath});
  Future<void> revokeToken({required String refreshToken});
  Future<void> depositToWallet({
    required double amount,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  });
  Future<List<WalletTransactionEntity>> getWalletHistory();
  Future<void> updateLanguage({required String languageCode});
}

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final Dio dio;
  ProfileRemoteDatasourceImpl({required this.dio});
  @override
  Future<ProfileModel> getProfile() async {
    try {
      final res = await dio.get(ApiConstants.userMe);
      final body = res.data as Map<String, dynamic>;
      debugPrint('📦 [Profile] raw data: ${body['data']}');
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
    int? idType,
    String? idNumber,
  }) async {
    try {
      final body = <String, dynamic>{
        'firstName': firstName,
        'lastName': lastName,
        'familyName': familyName,
        'email': email,
        'phoneNumber': phoneNumber,
      };
      if (idType != null) body['idType'] = idType;
      if (idNumber != null && idNumber.isNotEmpty) body['idNumber'] = idNumber;
      final res = await dio.put(ApiConstants.userMe, data: body);
      final bodyRes = res.data as Map<String, dynamic>;
      if (bodyRes['success'] != true) {
        final errors =
            (bodyRes['errors'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [];
        throw ServerException(
          message: bodyRes['message'] ?? 'Update failed',
          errors: errors,
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
      final rawUrl = data['profilePictureUrl'] as String;
      return ApiConstants.mediaUrl(rawUrl)!;
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  @override
  Future<void> revokeToken({required String refreshToken}) async {
    try {
      await dio.post(ApiConstants.revoke, data: {'refreshToken': refreshToken});
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        return;
      }
      _handleDio(e);
    }
  }

  @override
  Future<void> depositToWallet({
    required double amount,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  }) async {
    try {
      final res = await dio.post(
        ApiConstants.walletDeposit,
        data: {
          'amount': amount,
          'mockCardNumber': cardNumber,
          'expiryDate': expiryDate,
          'cvv': cvv,
        },
      );
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(message: body['message'] ?? 'Deposit failed');
      }
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  @override
  Future<List<WalletTransactionEntity>> getWalletHistory() async {
    try {
      final res = await dio.get('/Wallet/history');
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] ?? 'Failed to load history',
        );
      }
      final list = (body['data'] as List<dynamic>? ?? []);
      return list.map((e) {
        final json = e as Map<String, dynamic>;
        return WalletTransactionEntity(
          id: json['id'] as int,
          amount: (json['amount'] as num).toDouble(),
          type: json['type'] as String? ?? '',
          description: json['description'] as String? ?? '',
          bookingId: json['bookingId'] as int?,
          createdAt:
              DateTime.tryParse(json['createdAt'] as String? ?? '') ??
              DateTime.now(),
        );
      }).toList();
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  @override
  Future<void> updateLanguage({required String languageCode}) async {
    try {
      final res = await dio.put(
        ApiConstants.changeLanguage,
        data: {'language': languageCode},
      );
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] ?? 'Failed to update language',
        );
      }
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
