class ApiConstants {
  static const String baseUrl =
      'https://rehlabussines2-001-site1.anytempurl.com/api';
  static const String mediaBase =
      'https://rehlabussines2-001-site1.anytempurl.com';
  static const String register = '/Auth/register';
  static const String login = '/Auth/login';
  static const String refresh = '/Auth/refresh';
  static const String revoke = '/Auth/revoke';
  static const String revokeAll = '/Auth/revoke-all';
  static const String me = '/Auth/me';
  static const String sendVerificationEmail = '/Auth/send-verification-email';
  static const String verifyEmail = '/Auth/verify-email';
  static const String forgotPassword = '/Auth/forgot-password';
  static const String resetPassword = '/Auth/reset-password';
  static const String changePassword = '/Auth/change-password';
  static const String countries = '/Countries';
  static const String userMe = '/Users/me';
  static const String userProfilePicture = '/Users/me/profile-picture';
  static const String stations = '/Stations';
  static const String search = '/trips/search';
  static const String searchIndirect = '/trips/search/indirect';
  static const String popularRoutes = '/Search/popular-routes';
  static String seatMap(int occurrenceId) => '/occurrences/$occurrenceId/seats';
  static const String cartAdd = '/Bookings/cart';
  static const String checkout = '/Bookings/checkout';
  static const String myTickets = '/Bookings/my-tickets';
  static const String walletDeposit = '/Wallet/deposit';
  static const String marketplaceList = '/Marketplace/list';
  static const String marketplaceBuy = '/Marketplace/buy';
  static const String marketplaceActive = '/Marketplace/active';
  static const String marketplaceCancel = '/Marketplace/cancel';
  static const String notifications = '/Notifications';
  static String readNotification(String id) => '/Notifications/$id/read';
  static String deleteNotification(String id) => '/Notifications/$id';
  static const String readAllNotifications = '/Notifications/read-all';
  static const String changeLanguage = '/Users/language';
  static const String supportTickets = '/Support/tickets';
  static const String fcmToken = '/Users/fcm-token';
  static String? mediaUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.toLowerCase().startsWith('http')) return path;
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '$mediaBase/$cleanPath';
  }
}
