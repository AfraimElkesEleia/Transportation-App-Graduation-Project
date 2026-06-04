import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotficationPermissionManager {
  static const _askedKey = 'notification_permission_asked';
  static Future<void> requestIfNeeded(BuildContext context) async {
    final android = FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final granted = await android?.areNotificationsEnabled() ?? true;
    if (granted) return;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_askedKey) ?? false) return;
    await prefs.setBool(_askedKey, true);

    if (!context.mounted) return;
    await _showRationaleDialog(context, android);
  }

  static Future<void> _showRationaleDialog(
    BuildContext context,
    AndroidFlutterLocalNotificationsPlugin? android,
  ) async {
    final allow = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF112240),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: const Color(0xFF00B1DF).withValues(alpha: 0.25)),
        ),
        title: const Text(
          'Stay in the loop',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Get notified about offers on your tickets, '
          'boarding reminders, and cart expiry warnings.',
          style: TextStyle(color: Color(0xFF8BA0B8), height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Not now',
              style: TextStyle(color: Color(0xFF8BA0B8)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Allow',
              style: TextStyle(
                color: Color(0xFF00B1DF),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (allow == true) {
      await android?.requestNotificationsPermission();
    }
  }

  // for cart expiry and 30min boarding reminders
  static Future<void> requestExactAlarmIfNeeded() async {
    final android = FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final canSchedule = await android?.canScheduleExactNotifications() ?? true;
    if (!canSchedule) {
      await android?.requestExactAlarmsPermission();
    }
  }
}
