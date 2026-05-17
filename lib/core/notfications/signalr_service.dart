import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:transportation_app/core/constants/api_constants.dart';
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/notfications/notfication_service.dart';
import 'package:transportation_app/features/notfication/presentation/cubit/notfication_cubit.dart';

class SignalrService {
  static HubConnection? _hub;
  static bool _isConnecting = false;

  static Future<void> connect({
    required Future<String> Function() tokenFactory,
  }) async {
    if (_isConnecting || _hub?.state == HubConnectionState.Connected) return;
    _isConnecting = true;
    try {
      _hub = HubConnectionBuilder()
          .withUrl(
            '${ApiConstants.baseUrl}/hubs/notifications',
            options: HttpConnectionOptions(accessTokenFactory: tokenFactory),
          )
          .withAutomaticReconnect(retryDelays: [3000, 5000, 10000, 30000])
          .build();

      _hub!.on('ReceiveNotification', (args) {
        if (args == null || args.length < 3) return;
        final title = args[0] as String;
        final message = args[1] as String;
        final type = args[2] as String;
        NotficationService.showNotification(
          title: title,
          body: message,
          type: type,
        );
        // Refresh the inbox — new item has been saved server-side
        // The cubit re-fetches from GET /api/Notifications
        sl<NotificationCubit>().loadNotifications();
      });
      _hub!.onclose(({error}) async {
        // withAutomaticReconnect handles most cases,
        // this is a final fallback
        await Future.delayed(const Duration(seconds: 5));
        await _safeStart();
      });

      await _safeStart();
    } finally {
      _isConnecting = false;
    }
  }

  static Future<void> _safeStart() async {
    try {
      await _hub?.start();
    } catch (_) {
      // Connection failed — withAutomaticReconnect will retry
    }
  }

  static Future<void> disconnect() async {
    await _hub?.stop();
    _hub = null;
  }
}
