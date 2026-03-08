
import 'package:transportation_app/core/utils/token_manager.dart';

class AppStartup {
  final TokenManager tokenManager;
  AppStartup(this.tokenManager);
  Future<bool> isUserLoggedIn() async {
    final rememberMe   = await tokenManager.getRememberMe();
    final accessToken  = await tokenManager.getAccessToken();
    final refreshToken = await tokenManager.getRefreshToken();
    if (accessToken == null || refreshToken == null) return false;
    if (!rememberMe) {
      await tokenManager.clearTokens();
      return false;
    }
    return true;
  }
}