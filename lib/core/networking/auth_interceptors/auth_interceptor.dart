import 'package:dio/dio.dart';
import 'package:transportation_app/core/constants/api_constants.dart';
import 'package:transportation_app/core/utils/token_manager.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final TokenManager _tokenManager = TokenManager();
  static const _publicEndpoints = [
    ApiConstants.register,
    ApiConstants.login,
    ApiConstants.refresh,
    ApiConstants.forgotPassword,
    ApiConstants.resetPassword,
    ApiConstants.countries,
    ApiConstants.sendVerificationEmail,
    ApiConstants.verifyEmail,
  ];
  AuthInterceptor(this.dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isPublic = _publicEndpoints.any((e) => options.path.contains(e));
    if (!isPublic) {
      final token = await _tokenManager.getAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print(
      '🔵 [AuthInterceptor] onError called — status: ${err.response?.statusCode}',
    );
    final tokenExpired = err.response?.headers.value('Token-Expired') == 'true';
    if (tokenExpired) {
      print('🔵 [AuthInterceptor] token expired — trying silent refresh');
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        final newToken = await _tokenManager.getAccessToken();
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        final retried = await dio.fetch(err.requestOptions);
        return handler.resolve(retried);
      }
    }
    print('🔵 [AuthInterceptor] forwarding error to next handler');
    handler.next(err);
  }

  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = await _tokenManager.getRefreshToken();
      if (refreshToken == null) return false;
      final freshDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
      final response = await freshDio.post(
        ApiConstants.refresh,
        data: {'refreshToken': refreshToken},
      );

      if (response.data['success'] == true) {
        final data = response.data['data'];
        await _tokenManager.saveTokens(
          accessToken: data['accessToken'],
          refreshToken: data['refreshToken'],
        );
        return true;
      }
      return false;
    } catch (_) {
      await _tokenManager.clearTokens();
      return false;
    }
  }
}
