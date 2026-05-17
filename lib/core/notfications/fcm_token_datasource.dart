import 'package:dio/dio.dart';
import 'package:transportation_app/core/constants/api_constants.dart';

class FcmTokenDatasource {
  final Dio dio;
  FcmTokenDatasource(this.dio);

  /// POST /api/Users/fcm-token
  Future<void> registerToken({
    required String token,
    required String deviceType,
  }) async {
    await dio.post(
      ApiConstants.fcmToken,
      data: {'token': token, 'deviceType': deviceType},
    );
  }
}
