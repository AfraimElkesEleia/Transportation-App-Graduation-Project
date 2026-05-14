import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/features/notfication/data/datasources/notfication_remote_datasource.dart';
import 'package:transportation_app/features/notfication/domain/entities/app_notfication.dart';
import 'package:transportation_app/features/notfication/presentation/cubit/notfication_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotficationRemoteDatasource _datasource;

  NotificationCubit(this._datasource) : super(const NotificationInitial());

  // ── Load ───────────────────────────────────────────────────────────────────

  Future<void> loadNotifications() async {
    emit(const NotificationLoading());
    try {
      final items = await _datasource.getNotifications();
      emit(NotificationLoaded(notifications: items));
    } catch (_) {
      emit(const NotificationError('Failed to load notifications'));
    }
  }

  // ── Filter ─────────────────────────────────────────────────────────────────

  void changeFilter(NotificationFilter filter) {
    final current = state;
    if (current is NotificationLoaded) {
      emit(current.copyWith(activeFilter: filter));
    }
  }

  // ── Mark read (optimistic + backend) ──────────────────────────────────────

  Future<void> markRead(String notificationId) async {
    final current = state;
    if (current is! NotificationLoaded) return;

    final updated = current.notifications.map((n) {
      return n.id == notificationId ? n.copyWith(isRead: true) : n;
    }).toList();

    emit(current.copyWith(notifications: updated));

    try {
      await _datasource.markRead(notificationId);
    } catch (_) {
      // Optimistic update stands — backend sync will resolve on next load.
    }
  }

  // ── Mark all read (optimistic + backend) ──────────────────────────────────

  Future<void> markAllRead() async {
    final current = state;
    if (current is! NotificationLoaded) return;

    final updated = current.notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();

    emit(current.copyWith(notifications: updated));

    try {
      await _datasource.markAllRead();
    } catch (_) {
      // Optimistic update stands.
    }
  }

  // ── Dismiss locally (no backend delete endpoint) ───────────────────────────

  Future<void> dismiss(String notificationId) async {
    final current = state;
    if (current is! NotificationLoaded) return;

    final updated = current.notifications
        .where((n) => n.id != notificationId)
        .toList();

    emit(current.copyWith(notifications: updated));
  }

  // ── Offer actions (informational only — no sub-type from backend) ──────────

  Future<void> acceptOffer(String offerId) async {
    // Backend does not provide sub-type; no action endpoint available yet.
  }

  Future<void> rejectOffer(String offerId) async {
    // Backend does not provide sub-type; no action endpoint available yet.
  }
}