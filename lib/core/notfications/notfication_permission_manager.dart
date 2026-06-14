import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/routing/navigator_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotficationPermissionManager {
  static const _systemRequestAttemptedKey =
      'notification_permission_system_request_attempted';
  static bool _dialogVisible = false;

  static Future<void> requestIfNeeded(BuildContext context) async {
    if (!Platform.isAndroid || _dialogVisible) return;

    final android = FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return;

    final granted = await android.areNotificationsEnabled() ?? true;
    if (granted) return;

    final prefs = await SharedPreferences.getInstance();
    final systemRequestAttempted =
        prefs.getBool(_systemRequestAttemptedKey) ?? false;

    if (!systemRequestAttempted) {
      await prefs.setBool(_systemRequestAttemptedKey, true);
      await android.requestNotificationsPermission();

      final grantedAfterSystemRequest =
          await android.areNotificationsEnabled() ?? true;
      if (grantedAfterSystemRequest) return;
    }

    final overlayContext = navigatorKey.currentState?.overlay?.context;
    if (overlayContext == null || !overlayContext.mounted) return;
    await _showRationaleDialog(overlayContext);
  }

  static Future<void> _showRationaleDialog(BuildContext context) async {
    _dialogVisible = true;
    final loc = AppLocalizations.of(context)!;
    final allow = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF112240),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: const Color(0xFF00B1DF).withValues(alpha: 0.25),
          ),
        ),
        title: Text(
          loc.notificationPermissionTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          loc.notificationPermissionBody,
          style: const TextStyle(color: Color(0xFF8BA0B8), height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              loc.notificationPermissionNotNow,
              style: const TextStyle(color: Color(0xFF8BA0B8)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              loc.notificationPermissionOpenSettings,
              style: const TextStyle(
                color: Color(0xFF00B1DF),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
    _dialogVisible = false;

    if (allow == true) {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
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

class NotficationPermissionGate extends StatefulWidget {
  final Widget child;

  const NotficationPermissionGate({super.key, required this.child});

  @override
  State<NotficationPermissionGate> createState() =>
      _NotficationPermissionGateState();
}

class _NotficationPermissionGateState extends State<NotficationPermissionGate>
{
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkPermission());
  }

  Future<void> _checkPermission() async {
    if (!mounted) return;
    await NotficationPermissionManager.requestIfNeeded(context);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
