import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/features/notfication/domain/usecases/get_notifications_usecase.dart';
import 'package:transportation_app/features/notfication/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:transportation_app/features/notfication/domain/usecases/mark_notification_read_usecase.dart';
import 'package:transportation_app/features/notfication/presentation/cubit/notfication_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;
  final MarkAllNotificationsReadUseCase markAllNotificationsReadUseCase;

  NotificationCubit({
    required this.getNotificationsUseCase,
    required this.markNotificationReadUseCase,
    required this.markAllNotificationsReadUseCase,
  }) : super(const NotificationInitial());

  // ── Load ───────────────────────────────────────────────────────────────────

  Future<void> loadNotifications() async {
    emit(const NotificationLoading());
    final result = await getNotificationsUseCase();
    if (isClosed) return;
    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (items) => emit(NotificationLoaded(notifications: items)),
    );
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
      await markNotificationReadUseCase(notificationId);
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
      await markAllNotificationsReadUseCase();
    } catch (_) {
      // Optimistic update stands.
    }
  }

  // ── Offer actions (informational only — no sub-type from backend) ──────────

  Future<void> acceptOffer(String offerId) async {
    // Backend does not provide sub-type; no action endpoint available yet.
  }

  Future<void> rejectOffer(String offerId) async {
    // Backend does not provide sub-type; no action endpoint available yet.
  }
}
