import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/utils/error_localizer.dart';
import 'package:transportation_app/core/widgets/basic_container.dart';
import 'package:transportation_app/features/notfication/domain/entities/app_notfication.dart';
import 'package:transportation_app/features/notfication/presentation/cubit/notfication_cubit.dart';
import 'package:transportation_app/features/notfication/presentation/cubit/notfication_state.dart';
import 'package:transportation_app/features/notfication/presentation/widgets/notfication_app_bar.dart';
import 'package:transportation_app/features/notfication/presentation/widgets/notfication_card.dart';
import 'package:transportation_app/features/notfication/presentation/widgets/notfication_empty_state.dart';
import 'package:transportation_app/features/notfication/presentation/widgets/notfication_filter_bar.dart';
import 'package:transportation_app/features/notfication/presentation/widgets/notfication_section_header.dart';

/// Notification Inbox Screen.
class NotificationInboxScreen extends StatefulWidget {
  const NotificationInboxScreen({super.key});

  @override
  State<NotificationInboxScreen> createState() =>
      _NotificationInboxScreenState();
}

class _NotificationInboxScreenState extends State<NotificationInboxScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().loadNotifications();
  }

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
    return BlocConsumer<NotificationCubit, NotificationState>(
      listenWhen: (previous, current) {
        if (current is! NotificationLoaded) return false;
        final previousLoaded = previous is NotificationLoaded ? previous : null;
        return (current.deleteErrorMessage != null &&
                current.deleteErrorMessage !=
                    previousLoaded?.deleteErrorMessage) ||
            (current.deleteSucceeded && previousLoaded?.deleteSucceeded != true);
      },
      listener: (context, state) {
        if (state is! NotificationLoaded) return;
        final loc = AppLocalizations.of(context)!;
        final message = state.deleteErrorMessage != null
            ? ErrorLocalizer.localize(context, state.deleteErrorMessage!)
            : loc.notificationDeleted;

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(message),
              behavior: SnackBarBehavior.floating,
              backgroundColor: state.deleteErrorMessage != null
                  ? ColorsManager.error
                  : ColorsManager.cyanBlue,
            ),
          );
      },
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
                        label: _sectionLabel(context, entry.key),
                        count: entry.value.length,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, i) {
                        final notif = entry.value[i];
                        return Dismissible(
                          key: ValueKey('notification-${notif.id}'),
                          direction: DismissDirection.horizontal,
                          background: _DeleteBackground(
                            alignment: Alignment.centerLeft,
                          ),
                          secondaryBackground: _DeleteBackground(
                            alignment: Alignment.centerRight,
                          ),
                          onDismissed: (_) => context
                              .read<NotificationCubit>()
                              .deleteNotification(notif.id),
                          child: NotificationCard(
                            notification: notif,
                            onTap: notif.isRead
                                ? null
                                : () => _onTap(context, notif),
                          ),
                        );
                      }, childCount: entry.value.length),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 6)),
                ],
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
    switch (notif.type) {
      case NotificationType.marketplace:
        context.read<NotificationCubit>().loadNotifications();
        // Navigator.of(context).pushNamed(AppRoutes.m);
        break;
      case NotificationType.boarding:
        // Navigator.of(context).pushNamed(AppRoutes.myTickets);
        break;
      case NotificationType.gamification:
        // Navigator.of(context).pushNamed(AppRoutes.pr);
        break;
      case NotificationType.refund:
        // Navigator.of(context).pushNamed(AppRoutes.myTickets);
        break;
      case NotificationType.general:
        break;
    }
  }

  String _sectionLabel(BuildContext context, String label) {
    final loc = AppLocalizations.of(context)!;
    if (label == 'Today') return loc.todayLabel;
    if (label == 'Yesterday') return loc.yesterdayLabel;
    return label;
  }
}

class _DeleteBackground extends StatelessWidget {
  final Alignment alignment;

  const _DeleteBackground({required this.alignment});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isStart = alignment == Alignment.centerLeft;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: ColorsManager.error.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsManager.error.withValues(alpha: 0.35)),
      ),
      child: Align(
        alignment: alignment,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: isStart ? TextDirection.ltr : TextDirection.rtl,
          children: [
            const Icon(
              Icons.delete_outline_rounded,
              color: ColorsManager.error,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              loc.deleteNotification,
              style: const TextStyle(
                color: ColorsManager.error,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
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
    _anim = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
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
                color: ColorsManager.cardUnread.withValues(alpha: _anim.value),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: ColorsManager.cardBorderUnread.withValues(alpha: 0.3),
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
    final loc = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 40,
            color: ColorsManager.textMuted.withValues(alpha: 0.4),
          ),
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
                color: ColorsManager.cyanBlue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorsManager.cyanBlue.withValues(alpha: 0.25),
                ),
              ),
              child: Text(
                loc.tryAgain,
                style: const TextStyle(
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
