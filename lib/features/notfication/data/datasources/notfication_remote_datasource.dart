import 'package:dio/dio.dart';
import 'package:transportation_app/features/notfication/data/models/notfication_model.dart';
import 'package:transportation_app/features/notfication/domain/entities/app_notfication.dart';

// ── Contract ──────────────────────────────────────────────────────────────────

abstract class NotficationRemoteDatasource {
  /// Fetches the latest 50 notifications from GET /api/Notifications.
  Future<List<AppNotification>> getNotifications();

  /// Marks a single notification as read via PATCH /api/Notifications/{id}/read.
  Future<void> markRead(String id);

  /// Marks all notifications as read via PATCH /api/Notifications/read-all.
  Future<void> markAllRead();
}

// ── Implementation ────────────────────────────────────────────────────────────

class NotficationRemoteDatasourceImpl implements NotficationRemoteDatasource {
  final Dio dio;

  NotficationRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<AppNotification>> getNotifications() async {
    final res = await dio.get(
      '/api/Notifications',
      queryParameters: {'limit': 50},
    );
    final body = res.data as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>? ?? [];
    return data
        .map((j) => NotficationModel.fromJson(j as Map<String, dynamic>).toEntity())
        .toList();
  }

  @override
  Future<void> markRead(String id) async {
    await dio.patch('/api/Notifications/$id/read');
  }

  @override
  Future<void> markAllRead() async {
    await dio.patch('/api/Notifications/read-all');
  }
}
