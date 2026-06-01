import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:transportation_app/core/l10n/locale_box.dart';
import 'package:transportation_app/core/notfications/notfication_permission_manager.dart';

class LocalAlarmScheduler {
  static bool _tzReady = false;

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static Future<void> _initTimezone() async {
    if (_tzReady) return;
    tz.initializeTimeZones();
    try {
      final timezoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneName.identifier));
      _tzReady = true;
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
      _tzReady = true;
    }
  }

  static Future<void> scheduleCartExpiry({
    required DateTime holdExpiresAt,
  }) async {
    await _initTimezone();
    await NotficationPermissionManager.requestExactAlarmIfNeeded();
    final localExpiresAt = holdExpiresAt.isUtc
        ? holdExpiresAt.toLocal()
        : holdExpiresAt;
    DateTime triggerAt = localExpiresAt.subtract(const Duration(minutes: 3));
    if (triggerAt.isBefore(DateTime.now())) {
      if (localExpiresAt.isBefore(DateTime.now())) return;
      triggerAt = DateTime.now().add(const Duration(seconds: 5));
    }

    final box = Hive.box(LocaleBox.boxName);
    final isAr = (box.get(LocaleBox.localeKey) as String? ?? 'ar') == 'ar';
    final title = isAr ? '⏰ أوشكت صلاحية الجلسة على الانتهاء!' : '⏰ Seats About to Be Released!';
    final body = isAr
        ? 'تنتهي صلاحية سلتك خلال 3 دقائق. أكمل الدفع الآن.'
        : 'Your cart expires in 3 minutes. Complete checkout now.';

    await _plugin.zonedSchedule(
      id: 1001,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(triggerAt, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'rehla_urgent',
          'Urgent Alerts',
          channelDescription: 'Urgent cart expiry and boarding reminders',
          importance: Importance.max,
          priority: Priority.max,
          category: AndroidNotificationCategory.alarm,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'cart',
    );
  }

  static Future<void> cancelCartExpiry() async {
    await _plugin.cancel(id: 1001);
  }
}
