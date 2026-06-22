import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:transportation_app/core/notfications/notfication_service.dart';

/// Top-level handler for background FCM messages (required to be top-level).
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // flutter_local_notifications will display it automatically if
  // the notification payload is set on the server side.
  // No extra action needed here unless you want custom logic.
  log('[FCM] Background message: ${message.notification?.title}');
}

class FcmService {
  static final _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    if (!Platform.isAndroid) {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((message) {
      final notif = message.notification;
      if (notif == null) return;
      NotficationService.showNotification(
        title: notif.title ?? '',
        body: notif.body ?? '',
        type: message.data['type'] ?? 'Marketplace',
      );
    });
  }

  /// Returns the FCM device token (null if unavailable).
  static Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      log('[FCM] getToken failed: $e');
      return null;
    }
  }

  /// Device type string for the backend payload.
  static String get deviceType => Platform.isAndroid ? 'Android' : 'iOS';
}
