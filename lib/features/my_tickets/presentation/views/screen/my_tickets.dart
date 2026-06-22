import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/widgets/app_shimmer.dart';
import 'package:transportation_app/core/widgets/basic_container.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/marketplace_cubit.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/marketplace_states.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/my_tickets_cubit.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/my_tickets_states.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/action_buttons_row.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/ticket_detail_card.dart';
import 'package:transportation_app/features/my_tickets/domain/entities/ticket_entity.dart';

class MyTickets extends StatefulWidget {
  const MyTickets({super.key});

  @override
  State<MyTickets> createState() => _MyTicketsState();
}

class _MyTicketsState extends State<MyTickets>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    context.read<MyTicketsCubit>().loadAll();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context.read<MyTicketsCubit>().loadAll();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => sl<MarketplaceCubit>(),
      child: Scaffold(
        body: BasicContainer(
          child: SafeArea(
            child: BlocListener<MarketplaceCubit, MarketplaceState>(
              listener: (context, state) {
                if (state is MarketplaceListedState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.actionSuccessful),
                      backgroundColor: Colors.green,
                    ),
                  );
                  context.read<MyTicketsCubit>().fetchTickets();
                } else if (state is MarketplaceListErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: NestedScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    // ── App Bar ───────────────────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.myTickets,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  Text(
                                    l10n.digitalWallet,
                                    style: TextStyle(
                                      color: Colors.blue[200],
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: _onRefresh,
                              icon: const Icon(
                                Icons.refresh_rounded,
                                color: ColorsManager.accentCyan,
                              ),
                              tooltip: l10n.tapRefresh,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 16)),

                    // ── Marketplace / Resell actions ───────────────────
                    ActionButtonsRow(
                      marketPlaceButton: () =>
                          context.pushNamed(AppRoutes.marketPlaceScreen),
                      resellButton: () => context.pushNamed(
                        AppRoutes.resellTicketsScreen,
                        arguments: context.read<MyTicketsCubit>(),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 20)),

                    // ── Tabs header (Sticky) ──────────────────────────
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _StickyTabBarDelegate(
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorsManager.surfaceMid,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: TabBar(
                            controller: _tabCtrl,
                            indicator: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  ColorsManager.profileGradientStart,
                                  ColorsManager.profileGradientEnd,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white38,
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                            dividerColor: Colors.transparent,
                            tabs: [
                              Tab(text: l10n.upcoming),
                              Tab(text: l10n.active),
                              Tab(text: l10n.past),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                // ── Ticket list ───────────────────────────────────
                body: BlocBuilder<MyTicketsCubit, MyTicketsState>(
                  buildWhen: (_, c) =>
                      c is TicketsLoadingState ||
                      c is TicketsLoadedState ||
                      c is TicketsErrorState,
                  builder: (context, state) {
                    List<Widget> tabChildren;

                    if (state is TicketsLoadingState ||
                        state is MyTicketsInitial) {
                      final loadingView = ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        itemCount: 4,
                        itemBuilder: (_, __) => const AppShimmerCard(),
                      );
                      tabChildren = [loadingView, loadingView, loadingView];
                    } else if (state is TicketsErrorState) {
                      final errorView = _ErrorView(
                        message: state.message,
                        onRetry: () =>
                            context.read<MyTicketsCubit>().fetchTickets(),
                      );
                      tabChildren = [errorView, errorView, errorView];
                    } else if (state is TicketsLoadedState) {
                      final now = DateTime.now();
                      final upcoming = state.tickets
                          .where((t) => t.isUpcomingTicket(now))
                          .toList()
                        ..sort(_sortByBoardingSoonest);

                      final activeNow = state.tickets
                          .where((t) => t.isActiveTicket(now))
                          .toList()
                        ..sort(_sortByBoardingSoonest);
                      final past = state.tickets
                          .where((t) => t.isPastTicket(now))
                          .toList()
                        ..sort(_sortByDropoffMostRecent);

                      tabChildren = [
                        _TicketListView(
                          tickets: upcoming,
                          emptyLabel: l10n.noUpcomingTrips,
                        ),
                        _TicketListView(
                          tickets: activeNow,
                          emptyLabel: l10n.noActiveTrips,
                          showUrgency: true,
                        ),
                        _TicketListView(
                          tickets: past,
                          emptyLabel: l10n.noPastTrips,
                        ),
                      ];
                    } else {
                      // Fallback
                      final fallbackView = Center(
                        child: Text(
                          l10n.useRefresh,
                          style: const TextStyle(color: Colors.white38),
                        ),
                      );
                      tabChildren = [fallbackView, fallbackView, fallbackView];
                    }

                    return TabBarView(
                      controller: _tabCtrl,
                      children: tabChildren,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

int _sortByBoardingSoonest(TicketEntity a, TicketEntity b) {
  final timeCompare = a.boardingTime.compareTo(b.boardingTime);
  if (timeCompare != 0) return timeCompare;
  return a.bookingId.compareTo(b.bookingId);
}

int _sortByDropoffMostRecent(TicketEntity a, TicketEntity b) {
  final timeCompare = b.dropoffTime.compareTo(a.dropoffTime);
  if (timeCompare != 0) return timeCompare;
  return b.bookingId.compareTo(a.bookingId);
}

// ── Error view ───────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off_rounded, color: Colors.white24, size: 56),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.retry),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManager.accentCyan,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketListView extends StatelessWidget {
  final List<TicketEntity> tickets;
  final String emptyLabel;
  final bool showUrgency;

  const _TicketListView({
    required this.tickets,
    required this.emptyLabel,
    this.showUrgency = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.airplane_ticket_outlined,
              color: Colors.white12,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              emptyLabel,
              style: const TextStyle(color: Colors.white38, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.refreshTickets,
              style: const TextStyle(color: Colors.white24, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      itemCount: tickets.length,
      itemBuilder: (_, index) {
        return TicketDetailCard(
          ticket: tickets[index],
          showUrgency: showUrgency,
        );
      },
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyTabBarDelegate({required this.child});

  @override
  double get minExtent => 64.0;

  @override
  double get maxExtent => 64.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.transparent, // Match the scaffold background color
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _StickyTabBarDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
