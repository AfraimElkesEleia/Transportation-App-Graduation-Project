import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:transportation_app/core/constants/api_constants.dart';
import 'package:transportation_app/core/routing/navigator_key.dart';
import 'package:transportation_app/core/utils/token_manager.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/notfications/signalr_service.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final TokenManager _tokenManager = TokenManager();
  Future<_RefreshResult>? _refreshFuture;
  bool _isLoggingOut = false;
  static const _retriedAfterRefreshKey = 'retriedAfterRefresh';
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
    debugPrint(
      '🔵 [AuthInterceptor] onError called — status: ${err.response?.statusCode}',
    );
    final isPublic = _publicEndpoints.any(
      (e) => err.requestOptions.path.contains(e),
    );
    final statusCode = err.response?.statusCode;
    final tokenExpired = err.response?.headers.value('Token-Expired') == 'true';
    final alreadyRetried =
        err.requestOptions.extra[_retriedAfterRefreshKey] == true;
    final shouldTryRefresh =
        !isPublic && !alreadyRetried && (tokenExpired || statusCode == 401);

    if (shouldTryRefresh) {
      debugPrint('🔵 [AuthInterceptor] trying silent token refresh');
      final refreshResult = await _refreshTokenOnce();
      if (refreshResult == _RefreshResult.refreshed) {
        final newToken = await _tokenManager.getAccessToken();
        if (newToken == null) {
          await _forceLogout();
          return handler.next(err);
        }
        err.requestOptions.extra[_retriedAfterRefreshKey] = true;
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        try {
          final retried = await dio.fetch(err.requestOptions);
          return handler.resolve(retried);
        } on DioException catch (retryError) {
          return handler.next(retryError);
        }
      }

      if (refreshResult == _RefreshResult.invalidSession) {
        await _forceLogout();
      }
    } else if (!isPublic && alreadyRetried && statusCode == 401) {
      await _forceLogout();
    }
    debugPrint('🔵 [AuthInterceptor] forwarding error to next handler');
    handler.next(err);
  }

  Future<void> _forceLogout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    await _tokenManager.clearAllTokens();
    SignalrService.disconnect();
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.loginScreen,
      (route) => false,
    );
  }

  Future<_RefreshResult> _refreshTokenOnce() {
    final refreshFuture = _refreshFuture;
    if (refreshFuture != null) return refreshFuture;

    final future = _tryRefreshToken();
    _refreshFuture = future;
    return future.whenComplete(() {
      if (identical(_refreshFuture, future)) {
        _refreshFuture = null;
      }
    });
  }

  Future<_RefreshResult> _tryRefreshToken() async {
    try {
      final refreshToken = await _tokenManager.getRefreshToken();
      if (refreshToken == null) return _RefreshResult.invalidSession;

      final freshDio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          contentType: 'application/json',
          headers: {'Accept': 'application/json'},
        ),
      );
      final response = await freshDio.post(
        ApiConstants.refresh,
        data: {'refreshToken': refreshToken},
      );

      final body = response.data as Map<String, dynamic>?;
      if (body?['success'] == true) {
        final data = body?['data'] as Map<String, dynamic>?;
        if (data == null ||
            data['accessToken'] is! String ||
            data['refreshToken'] is! String) {
          return _RefreshResult.failed;
        }
        await _tokenManager.saveTokens(
          accessToken: data['accessToken'],
          refreshToken: data['refreshToken'],
        );
        return _RefreshResult.refreshed;
      }

      return _RefreshResult.invalidSession;
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
        return _RefreshResult.invalidSession;
      }
      debugPrint(
        '🔵 [AuthInterceptor] refresh failed without invalidating session: ${error.message}',
      );
      return _RefreshResult.failed;
    } catch (error) {
      debugPrint(
        '🔵 [AuthInterceptor] unexpected refresh failure: $error',
      );
      return _RefreshResult.failed;
    }
  }
}

enum _RefreshResult {
  refreshed,
  invalidSession,
  failed,
}
