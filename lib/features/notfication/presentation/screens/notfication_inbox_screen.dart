import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/widgets/basic_container.dart';
import 'package:transportation_app/features/notfication/domain/entities/app_notfication.dart';
import 'package:transportation_app/features/notfication/presentation/cubit/notfication_cubit.dart';
import 'package:transportation_app/features/notfication/presentation/cubit/notfication_state.dart';
import 'package:transportation_app/features/notfication/presentation/widgets/notfication_app_bar.dart';
import 'package:transportation_app/features/notfication/presentation/widgets/notfication_card.dart';
import 'package:transportation_app/features/notfication/presentation/widgets/notfication_empty_state.dart';
import 'package:transportation_app/features/notfication/presentation/widgets/notfication_filter_bar.dart';
import 'package:transportation_app/features/notfication/presentation/widgets/notfication_section_header.dart';
import 'package:transportation_app/features/notfication/presentation/widgets/notfication_type_config.dart';

/// Notification Inbox Screen.
class NotificationInboxScreen extends StatelessWidget {
  const NotificationInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: SafeArea(
          child: BasicContainer(
            child: Column(
              children: [
                NotficationAppBar(),
                const SizedBox(height: 4),
                _FilterSection(),
                const SizedBox(height: 12),
                Expanded(child: _NotificationList()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Filter section ───────────────────────────────────────────────────────────

class _FilterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        final loaded = state is NotificationLoaded ? state : null;
        return NotificationFilterBar(
          active: loaded?.activeFilter ?? NotificationFilter.all,
          unreadCount: loaded?.unreadCount ?? 0,
          onChanged: (f) => context.read<NotificationCubit>().changeFilter(f),
        );
      },
    );
  }
}

// ─── Notification list ────────────────────────────────────────────────────────

class _NotificationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        if (state is NotificationLoading || state is NotificationInitial) {
          return const _LoadingShimmer();
        }

        if (state is NotificationError) {
          return _ErrorState(message: state.message);
        }

        if (state is NotificationLoaded) {
          final grouped = state.grouped;

          if (grouped.isEmpty) {
            return NotificationEmptyState(filter: state.activeFilter.name);
          }

          return RefreshIndicator(
            color: ColorsManager.cyanBlue,
            backgroundColor: ColorsManager.cardUnread,
            onRefresh: () =>
                context.read<NotificationCubit>().loadNotifications(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                for (final entry in grouped.entries) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: NotificationSectionHeader(
                        label: entry.key,
                        count: entry.value.length,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final notif = entry.value[i];
                          return NotificationCard(
                            notification: notif,
                            onTap: () => _onTap(context, notif),
                            onDismiss: () =>
                                context.read<NotificationCubit>().dismiss(notif.id),
                            onAccept: NotificationTypeConfig.hasActions(notif.type)
                                ? () => _onAccept(context, notif)
                                : null,
                            onDecline: NotificationTypeConfig.hasActions(notif.type)
                                ? () => _onDecline(context, notif)
                                : null,
                          );
                        },
                        childCount: entry.value.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 6)),
                ],
                const SliverToBoxAdapter(child: _SwipeHint()),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _onTap(BuildContext context, AppNotification notif) {
    context.read<NotificationCubit>().markRead(notif.id);
    // Navigate based on type when deep-link targets are ready.
    switch (notif.type) {
      case NotificationType.offerReceived:
      case NotificationType.counterOfferReceived:
        break;
      case NotificationType.offerAccepted:
        break;
      case NotificationType.offerRejected:
        break;
      case NotificationType.ticketSold:
        break;
    }
  }

  void _onAccept(BuildContext context, AppNotification notif) {
    context.read<NotificationCubit>().markRead(notif.id);
    context.read<NotificationCubit>().acceptOffer(notif.offerId ?? '');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ColorsManager.successGreen.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(
          'Offer accepted for ${notif.offeredPrice ?? ""} EGP',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _onDecline(BuildContext context, AppNotification notif) {
    context.read<NotificationCubit>().markRead(notif.id);
    context.read<NotificationCubit>().rejectOffer(notif.offerId ?? '');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ColorsManager.cardUnread,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: const Text(
          'Offer declined',
          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

// ─── Swipe hint ───────────────────────────────────────────────────────────────

class _SwipeHint extends StatelessWidget {
  const _SwipeHint();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.swipe_left_rounded,
              size: 13, color: ColorsManager.textMuted.withOpacity(0.3)),
          const SizedBox(width: 6),
          Text(
            'Swipe left to dismiss',
            style: TextStyle(
              fontSize: 11,
              color: ColorsManager.textMuted.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Loading shimmer ──────────────────────────────────────────────────────────

class _LoadingShimmer extends StatefulWidget {
  const _LoadingShimmer();

  @override
  State<_LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<_LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: List.generate(
            4,
            (i) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              height: 88,
              decoration: BoxDecoration(
                color: ColorsManager.cardUnread.withOpacity(_anim.value),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: ColorsManager.cardBorderUnread.withOpacity(0.3),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Error state ──────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded,
              size: 40, color: ColorsManager.textMuted.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ColorsManager.textMuted,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => context.read<NotificationCubit>().loadNotifications(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: ColorsManager.cyanBlue.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorsManager.cyanBlue.withOpacity(0.25),
                ),
              ),
              child: const Text(
                'Try again',
                style: TextStyle(
                  color: ColorsManager.cyanBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}