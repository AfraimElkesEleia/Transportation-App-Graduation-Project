import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/main.dart';

class NotficationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false, // We request separately — see Step 2
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onTap,
    );
    await _createChannels();
  }

  static Future<void> _createChannels() async {
    final androidPlugin = AndroidFlutterLocalNotificationsPlugin();
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'rehla_marketplace',
        'Marketplace Activity',
        description: 'Offers, counter-offers, and sales notifications',
        importance: Importance.high,
      ),
    );
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'rehla_boarding',
        'Boarding Reminders',
        description: 'Trip departure reminders',
        importance: Importance.high,
      ),
    );
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'rehla_urgent',
        'Urgent Alerts',
        description: '30-minute boarding and cart expiry alerts',
        importance: Importance.max,
      ),
    );
  }

  static void _onTap(NotificationResponse response) {
    final payload = response.payload ?? '';
    log('Notification tapped with payload: $payload');

    if (payload == 'cart') {
      navigatorKey.currentState?.pushNamed(AppRoutes.cartScreen);
    } else {
      navigatorKey.currentState?.pushNamed(AppRoutes.homeScreen);
    }
  }

  static Future<void> showNotification({
    required String title,
    required String type, // "marketplace", "boarding", or "urgent"
    required String body,
  }) async {
    final channelId = type == 'Marketplace'
        ? 'rehla_marketplace'
        : 'rehla_boarding';
    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelId == 'rehla_marketplace'
              ? 'Marketplace Activity'
              : 'Boarding Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: type.toLowerCase(),
    );
  }
}
